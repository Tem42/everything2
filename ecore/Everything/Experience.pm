package Everything::Experience;
#
#
#	Experience.pm
#
#	A module to encapsulate the functions dealing with the voting system
#	as well as experience points and levels
#
#	Nathan Oostendorp 2000
###########################################################################

use strict;
use Everything;

sub BEGIN
{
	use Exporter ();
	use vars       qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
	@ISA=qw(Exporter);
	@EXPORT=qw(
		castVote
		adjustExp
		adjustRepAndVoteCount
		adjustGP
		allocateVotes
		hasVoted
		getVotes
		getLevel
		getHRLF
		calculateBonus
	);
}

#######################################################################
#
#	getLevel
#
#	given a user, return his level.  This info is stored in the
#	"level settings" node
#
sub getLevel {
	my ($USER) = @_;
	getRef($USER);
	return $$USER{level} if $$USER{level};
	return 0 if $$USER{title} eq "Guest User";

	my $exp = $$USER{experience};
	my $V = getVars ($USER);
        my $numwriteups = $$V{numwriteups};

	#honor roll here:
	#if (!$$V{settings_useWriteupBonus}) {
	#	$numwriteups /= getHRLF($USER);
	#}
	#else {
	#	$$V{writeupbonus} = calculateBonus($USER);
	#	$numwriteups += $$V{writeupbonus};
	#}

        my $EXP = getVars(getNode('level experience','setting'));
	my $WRP = getVars(getNode('level writeups', 'setting'));

		my $maxlevel = 1;
		while (exists $$EXP{$maxlevel}) { $maxlevel++ }
	if ($$USER{title} eq 'nate' or $$USER{title} eq 'dbrown') {

		return $maxlevel-1;
        }
        
	$exp ||= 0;
	$numwriteups ||= 0;
        my $level = 0;
        for (my $i = 1; $i < $maxlevel; $i++) {
                if ($exp >= $$EXP{$i} and $numwriteups >= $$WRP{$i}) {
                        $level = $i;
                }
        }

        $level;
}

########################################################################
#
#	allocateVotes
#
#	give votes to a specific user.  it's assumed that at some point 
#	at a given interval, each user is allocated their share of votes
#
sub allocateVotes {
	my ($USER, $numvotes) = @_;
	getRef($USER);

	$$USER{votesleft} = $numvotes;
	updateNode($USER, -1);
}

#########################################################################
#
#	adjustRepAndVoteCount
#
#	adjust reputation points for a node as well as vote count, potentially
#
sub adjustRepAndVoteCount {
	my ($NODE, $pts, $voteChange) = @_;
	getRef($NODE);

	$$NODE{reputation} += $pts;
	# Rely on updateNode to discard invalid hash entries since
	#  not all voteable nodes may have a totalvotes column
	$$NODE{totalvotes} += $voteChange;
	updateNode($NODE, -1);
}

##########################################################################
#
#	adjustExp
#
#	adjust experience points
#
#	ideally we could optimize this, since its only inc one field.
#
sub adjustExp {
	my ($USER, $points) = @_;
	getRef($USER);
	#$USER = getNodeById(getId($USER), 'force');

	$$USER{experience} += $points;

	# Only update user immediately if we're not in a transaction
	updateNode($USER, -1) if $DB->{dbh}->{AutoCommit};
	1;
}

###
#
#       adjust GP
#
#       ideally we could optimize this, since its only inc one field.
#
sub adjustGP {
        my ($USER, $points) = @_;
        getRef($USER);
        my $V=getVars($USER);
        return if ((exists $$V{GPoptout})&&(defined $$V{GPoptout}));
        $$USER{GP} += $points;
        updateNode($USER,-1);
        1;
}

###################################################################
#
#	getVotes
#
#	get votes for a certain node.  returns
#	a list of vote hashes.  If you specify a user, it returns
#	only the vote hash for the users vote (if exists)
#
sub getVotes {
	my ($NODE, $USER) = @_;

	return hasVoted($NODE, $USER) if $USER;

	my $csr = $DB->sqlSelectMany("*", "vote", "vote_id=".getId($NODE));
	my @votes;

	while (my $VOTE = $csr->fetchrow_hashref()) {
		push @votes, $VOTE;
	}
	
	@votes;
}

##########################################################################
#	hasVoted -- checks to see if the user has already voted on this Node
#
#	this is a primary key lookup, so it should be very fast
#
sub hasVoted {
	my ($NODE, $USER) = @_;

	my $VOTE = $DB->sqlSelect("*", 'vote', "vote_id=".getId($NODE)." 
		and voter_user=".getId($USER));

	return 0 unless $VOTE;
	$VOTE;
}

##########################################################################
#	insertVote -- inserts a users vote into the vote table
#
#	note, since user and node are the primary keys, the insert will fail
#	if the user has already voted on a given node.
#
sub insertVote {
	my ($NODE, $USER, $weight) = @_;
	my $ret = $DB->sqlInsert('vote', { vote_id => getId($NODE),
		voter_user => getId($USER),
		weight => $weight,
		-votetime => 'now()'
		});
	return 0 unless $ret;
	#the vote was unsucessful

	1;
}

###########################################################################
#
#	castVote
#
#	this function does a number of things -- sees if the user is
#	allowed to vote, inserts the vote, and allocates exp/rep points
#
sub castVote {
  my ($NODE, $USER, $weight, $noxp, $VSETTINGS) = @_;
  getRef($NODE, $USER);

  my $voteWrap = sub {

    my ($USER, $NODE, $AUTHOR) = @_;

    #return if they don't have any votes left today
    return unless $$USER{votesleft};

    #jb says: Allow for $VSETTINGS to be specified. This will save
    # us a few cycles in castVote
    $VSETTINGS ||= getVars(getNode('vote settings', 'setting'));
    my @votetypes = split /\s*\,\s*/, $$VSETTINGS{validTypes};

    #if no types are specified, the user can vote on anything
    #otherwise, they can only vote on "validTypes"
    return if (@votetypes and not grep(/^$$NODE{type}{title}$/, @votetypes));

    my $prevweight;
    $prevweight  = $DB->sqlSelect('weight',
                                  'vote',
                                  'voter_user='.$$USER{node_id}
                                  .' AND vote_id='.$$NODE{node_id}
                                  );

    # If user had already voted, update the table manually, check that the vote is
    # actually different.
    my $alreadyvoted = (defined $prevweight && $prevweight != 0);
    my $voteCountChange = 0;
    my $action;

    if (!$alreadyvoted) {

      insertVote($NODE, $USER, $weight);

      if ($$NODE{type}{title} eq 'poll') {
         $action = 'votepoll';
      } elsif ($weight > 0) {
         $action = 'voteup';
      } else {
         $action = 'votedown';
      }

      $voteCountChange = 1;

    } else {

        $DB->sqlUpdate("vote"
                       , { -weight => $weight, -revotetime => "NOW()" }
                       , "voter_user=$$USER{node_id}
                          AND vote_id=$$NODE{node_id}"
                       )
          unless $prevweight == $weight;

        if ($weight > 0) {
           $action = 'voteflipup';
        } else {
           $action = 'voteflipdown';
        }

    }

    Everything::HTML::recordUserAction($action, $$NODE{node_id});
    adjustRepAndVoteCount($NODE, $weight-$prevweight, $voteCountChange);

    #the node's author gains 1 XP for an upvote or a flipped up
    #downvote.
    if ($weight>0 and $prevweight <= 0) {
      adjustExp($AUTHOR, $weight);
    }
    #Revoting down, note the subtle difference with above condition
    elsif($weight < 0 and $prevweight > 0){
       adjustExp($AUTHOR, $weight);
    }


    #the voter has a chance of receiving a GP
    if (rand(1.0) < $$VSETTINGS{voterExpChance} &&  !$alreadyvoted) {
      adjustGP($USER, 1) unless($noxp);
      #jb says this is for decline vote XP option
      #we pass this $noxp if we want to skip the XP option
    }

    $$USER{votesleft}-- unless ($alreadyvoted and $weight==$prevweight);

  };

  my $superUser = -1;
  updateLockedNode(
    [ $$USER{user_id}, $$NODE{node_id}, $$NODE{author_user} ]
    , $superUser
    , $voteWrap
  );

  1;
}

sub getHRLF
{
  my ($USER) = @_;
  $$USER{numwriteups} ||= 0;
  return 1 if $$USER{numwriteups} < 25;
  return $$USER{HRLF} if $$USER{HRLF};
#  return 1 unless $$USER{title} eq "JayBonci" or $$USER{title} eq "Professor Pi";
  my $hrstats = getVars(getNode("hrstats", "setting"));
  
  return 1 unless $$USER{merit} > $$hrstats{mean};
  #return 1/(2-exp(-(($$USER{merit} - $$hrstats{mean})^2)/(2*($$hrstats{stddev}^2))));
  return 1/(2-exp(-(($$USER{merit}-$$hrstats{mean})**2)/(2*($$hrstats{stddev})**2)));
};


sub calculateBonus {

	my ($USER) = @_;
	getRef($USER);
	return 0 if $$USER{title} eq "Guest User";

	my $repStep = 26;
	my $repStep2 = 2 * $repStep;
	my $repStep3 = 3 * $repStep;

	my $user_id = $$USER{user_id};
return 0 unless $user_id;

	my $coolBonus = $DB->sqlSelect("sum(case cooled when 3 then 1 when 4 then 2 else 3 end) as coolBonus", "writeup inner join node on
 node_id=writeup_id","author_user=$user_id  and cooled>=3");

	my $writeupBonus = $DB->sqlSelect("sum(case when reputation between $repStep and ".($repStep2-1)." then 1 when reputation between
$repStep2 and ".($repStep3-1)." then 2 else 3 end) as repBonus", "node","author_user=$user_id  and reputation >=$repStep");

	my $totalBonus = $coolBonus + $writeupBonus;

	my $V = getVars($USER);
	$$V{writeupbonus} = $totalBonus;
	setVars($USER,$V);

return $totalBonus;

}

1;
