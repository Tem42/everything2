package Everything::Delegation::nodelet;

use strict;
use warnings;

BEGIN {
  *getNode = *Everything::HTML::getNode;
  *getNodeById = *Everything::HTML::getNodeById;
  *getVars = *Everything::HTML::getVars;
  *getId = *Everything::HTML::getId;
  *urlGen = *Everything::HTML::urlGen;
  *linkNode = *Everything::HTML::linkNode;
  *htmlcode = *Everything::HTML::htmlcode;
  *parseCode = *Everything::HTML::parseCode;
  *parseLinks = *Everything::HTML::parseLinks;
  *isNodetype = *Everything::HTML::isNodetype;
  *isGod = *Everything::HTML::isGod;
  *getRef = *Everything::HTML::getRef;
  *insertNodelet = *Everything::HTML::insertNodelet;
  *getType = *Everything::HTML::getType;
  *updateNode = *Everything::HTML::updateNode;
  *setVars = *Everything::HTML::setVars;
  *getNodeWhere = *Everything::HTML::getNodeWhere;
  *insertIntoNodegroup = *Everything::HTML::insertIntoNodegroup;
  *linkNodeTitle = *Everything::HTML::linkNodeTitle;
  *removeFromNodegroup = *Everything::HTML::removeFromNodegroup;
  *canUpdateNode = *Everything::HTML::canUpdateNode;
  *updateLinks = *Everything::HTML::updateLinks;
  *isMobile = *Everything::HTML::isMobile;
  *canReadNode = *Everything::HTML::canReadNode;
  *canDeleteNode = *Everything::HTML::canDeleteNode;
  *evalCode = *Everything::HTML::evalCode;
  *getPageForType = *Everything::HTML::getPageForType;
  *opLogin = *Everything::HTML::opLogin;
  *replaceNodegroup = *Everything::HTML::replaceNodegroup;
  *getPage = *Everything::HTML::getPage;
}

sub epicenter
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;

  my $str = "";
  $str .= htmlcode("borgcheck");

  return $str if $APP->isGuest($USER);
  my ($loginStr, $votesLeftStr, $expStr, $serverTimeStr);

  #####LOGIN STRING

  $loginStr = "
  <ul>
	<li>".linkNode($NODE, 'Log Out', {op=>'logout'})."</li>
	<li title=\"User Settings\">".linkNode($Everything::CONF->system->{user_settings}, '',{lastnode_id=>0})."</li>
	<li title=\"Your profile\">".linkNode($USER,0,{lastnode_id=>0}).' '.linkNode($USER,'<small>(edit)</small>',{displaytype=>'edit',lastnode_id=>0})."</li>
	<li title=\"Draft, format, and organize your works in progress\">".linkNode(getNode('Drafts','superdoc'))."</li>
	<li title=\"Learn what all those numbers mean\">".linkNode(getNode('The Everything2 Voting/Experience System','superdoc'), 'Voting/XP System')."</li>
	<li title=\"View a randomly selected node\">".htmlcode('randomnode','Random Node')."</li>
	<li title=\"Need help?\">".linkNode(getNode(
		($APP->getLevel($USER) < 2 ? 'E2 Quick Start' : 'Everything2 Help'),'e2node'), 'Help')."</li>
  </ul>";

  ###VOTES LEFT, XP

  my @thingys = ();

  my $c = (int $$VARS{cools}) || 0;
  my $v = (int $$USER{votesleft}) || 0;
  if($v !~ /^\d+$/) { $v = 0; }
  if ($c || $v)
  {
    if($c) { push @thingys, '<strong id="chingsleft">'.$c.'</strong> C!'.($c>1?'s':''); }
    if($v) { push @thingys, '<strong id="votesleft">'.$v.'</strong> vote'.($v>1?'s':''); }
  }

  if (scalar(@thingys))
  {
    $votesLeftStr = "\n\n\t".'<p id="voteschingsleft">You have ' . join(' and ',@thingys) . ' left today.</p>';
  }

  $expStr = "\n\n\t".'<p id="experience">'.htmlcode('shownewexp','TRUE').'</p>';

  unless ($$VARS{GPoptout})
  {
    $expStr .= "\n\n\t".'<p id="gp">'.htmlcode('showNewGP','TRUE').'</p>';
  }

  #### SERVER TIME

  my $NOW = time;
  $serverTimeStr='server time' . "<br />\n\t\t" . htmlcode('DateTimeLocal',$NOW.',1');

  if( (exists $VARS->{'localTimeUse'}) && $VARS->{'localTimeUse'} )
  {
    $serverTimeStr .= "<br />\n\t\t" . linkNodeTitle('Advanced Settings|your time') . "<br />\n\t\t" . htmlcode('DateTimeLocal',$NOW);
  } else {
    $serverTimeStr .= "<br />\n\t\t" . linkNodeTitle('Advanced Settings|(set your time)');
  }

  $serverTimeStr = '<p id="servertime">'.$serverTimeStr.'</p>';

  return $str.$loginStr .$votesLeftStr . $expStr . $serverTimeStr;
}

sub new_writeups
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;

  my $str = "";

  if(!$APP->isGuest($USER))
  {
    $str.= htmlcode('nwuamount');
  }
  $str .= htmlcode('zenwriteups');
  $str .= qq|<div class="nodeletfoot morelink">(|.linkNode(getNode('Writeups by Type', 'superdoc'), 'more').qq|)</div>|;

  return $str;
}

sub node_statistics
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;

  my $str = "";
  $str .= qq|Node ID: $NODE->{node_id} <br>|;
  $str .= qq|Created on: $NODE->{createtime} <br>|;
  $str .= qq|Hits: $NODE->{hits} <br>|;
  $str .= qq|Nodetype: |.linkNode($$NODE{type_nodetype}).qq|<br>|;
  $str .= qq|Display page: |.linkNode (getPage($NODE, $query->param("displaytype")));

  return $str;
}

sub other_users
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;

  my $str = "";

  $str .= htmlcode("changeroom","Other Users");

  my $wherestr = "";

  $$USER{in_room} = int($USER->{in_room});
  $USER->{in_room} = 0 unless getNodeById($USER->{in_room});
  if ($$USER{in_room}) {
    $wherestr = "room_id=$$USER{in_room} OR room_id=0";
  }

  my $UID = $$USER{node_id};
  my $isRoot = $APP->isAdmin($USER);
  my $isCE = $APP->isEditor($USER);
  my $isChanop = $APP->isChanop($USER);

  unless ($isCE || $$VARS{infravision}) {
    $wherestr.=' AND ' if $wherestr;
    $wherestr.='visible=0';
  }

  my $showActions = $$VARS{showuseractions} ? 1 : 0;

  my @doVerbs = ();
  my @doNouns = ();
  if ($showActions)
  {
    @doVerbs = ('eating', 'watching', 'stalking', 'filing',
              'noding', 'amazed by', 'tired of', 'crying for',
              'thinking of', 'fighting', 'bouncing towards',
              'fleeing from', 'diving into', 'wishing for',
              'skating towards', 'playing with',
              'upvoting', 'learning of', 'teaching',
              'getting friendly with', 'frowned upon by',
              'sleeping on', 'getting hungry for', 'touching',
              'beating up', 'spying on', 'rubbing', 'caressing', 
              ''        # leave this blank one in, so the verb is
                        # sometimes omitted
    );
  @doNouns = ('a carrot', 'some money', 'EDB', 'nails', 'some feet',
              'a balloon', 'wheels', 'soy', 'a monkey', 'a smurf',
              'an onion', 'smoke', 'the birds', 'you!', 'a flashlight',
              'hash', 'your speaker', 'an idiot', 'an expert', 'an AI',
              'the human genome', 'upvotes', 'downvotes',
              'their pants', 'smelly cheese', 'a pink elephant',
              'teeth', 'a hippopotamus', 'noders', 'a scarf',
              'your ear', 'killer bees', 'an angst sandwich',
              'Butterfinger McFlurry'
    );
  }

  my $newbielook = $isRoot || $isCE;

  my $powStructLink = '<a href='.urlGen({'node'=>'E2 staff', 'nodetype'=>'superdoc'})
                    . ' style="text-decoration: none;" ';
  my $linkRoots = $powStructLink . 'title="e2gods">@</a>';
  my $linkCEs = $powStructLink . 'title="Content Editors">$</a>';

  my $linkChanops = $powStructLink.'title="chanops">+</a>';

  my $linkBorged = '<a href='.urlGen({'node'=>'E2 FAQ: Chatterbox',
                                   'nodetype'=>'superdoc'})
                 .' style="text-decoration: none;" title="borged!">&#216;</a>';

  # no ordering from databse - sorting done entirely in perl, below
  my $csr = $DB->sqlSelectMany('*', 'room', $wherestr);

  my $num = 0;
  my $sameUser;   # if the user to show is the user that is loading the page
  my $userID;     # only get member_user from hash once
  my $n;          # nick
  my $is1337 = ($userID == 220 || $userID == 322);        # nate and hemos

  # Fetch users to ignore.
  my $ignorelist = $DB->sqlSelectMany('ignore_node', 'messageignore',
                                    'messageignore_id='.$UID);
  my (%ignore, $u);
  $ignore{$u} = 1 while $u = $ignorelist->fetchrow();
  $ignorelist->finish;

  my @noderlist;
  while(my $U = $csr->fetchrow_hashref())
  {
    $num++;
    $userID = $$U{member_user};

    my $jointime = $APP->convertDateToEpoch(getNodeById($userID)->{createtime});

    my $userVars = getVars(getNodeById($userID));

    my ($lastnode,$lastnodetime, $lastnodehidden);
    my $lastnodeid =  $userVars -> {lastnoded};
    if ($lastnodeid)
    {
      $lastnode = getNodeById($lastnodeid);
      $lastnodetime = $lastnode -> {publishtime};
      $lastnodehidden = $lastnode -> {notnew};

      # Nuked writeups can mess this up, so have to check there really
      # is a lastnodetime.
      $lastnodetime = $APP->convertDateToEpoch($lastnodetime) if $lastnodetime;
    }

    #Haven't been here for a month or haven't noded?
    if( time() - $jointime  < 2592000 || !$lastnodetime ){
      $lastnodetime = 0;
    }

    my $thisChanop = $APP->isChanop($userID,"nogods");

    $sameUser = $UID==$userID;
    next if $ignore{$userID} && !$isRoot;
    $n = $$U{nick};
    my $nameLink = linkNode($userID, $n);

    if (htmlcode('isSpecialDate','halloween'))
    {
      my $bAndBrackets = 1;
      my $costume = $$userVars{costume};
      if (defined $costume and $costume ne '')
      {
        $costume = encodeHTML($$userVars{costume}, $bAndBrackets);
        $nameLink = linkNode($userID, $costume);
      }
    }
    $nameLink = '<strong>'.$nameLink.'</strong>' if $sameUser;

    my $flags='';
    if ($APP->isAdmin($userID) && !$APP->getParameter($userID,"hide_chatterbox_staff_symbol") )
    {
      $flags .= $linkRoots;
    }

    if ($newbielook)
    {
      my $getTime = $DB->sqlSelect("datediff(now(),createtime)+1 as "
                                 ."difftime","node","node_id="
                                 .$userID." having difftime<31");

      if ($getTime)
      {
        if ($getTime<=3)
        {
          $flags.='<strong class="newdays" title="very new user">'.$getTime.'</strong>';
        } else {
          $flags.='<span class="newdays" title="new user">'.$getTime.'</span>'
        }
      }
    }

    if ($APP->isEditor($userID, "nogods") && !$APP->isAdmin($userID) && !$APP->getParameter($userID,"hide_chatterbox_staff_symbol") )
    {
      $flags .= $linkCEs;
    }

    $flags .= $linkChanops if $thisChanop;

    if ($isCE || $isChanop)
    {
      $flags .= $linkBorged if $$U{borgd}; # yes, no 'e' in 'borgd'
    }
    if ($$U{visible})
    {
      $flags.='<font color="#ff0000">i</font>';
    }

    if ($$U{room_id} != 0 and $$USER{in_room} == 0)
    {
      my $rm = getNodeById($$U{room_id});
      $flags .= linkNode($rm, '~');
    }

    $flags = ' &nbsp;[' . $flags . ']' if $flags;

    my $nameLinkAppend = "";

    if ($showActions && !$sameUser && (0.02 > rand()))
    {
      $nameLinkAppend = ' <small>is ' . $doVerbs[int(rand(@doVerbs))] 
                      . ' ' . $doNouns[int(rand(@doNouns))] 
                      . '</small>';
    }

    # jessicaj's idea, link to a user's latest writeup
    if ($showActions && (0.02 > rand()) )
    {
      if ((time() - $lastnodetime) < 604800 # One week since noding?
        && !$lastnodehidden) {
        my $lastnodeparent = getNodeById($$lastnode{parent_e2node});
        $nameLinkAppend = '<small> has recently noded '
                        . linkNode($lastnode,$$lastnodeparent{title})
                        . ' </small>';
      }

    }

    $nameLink .= $nameLinkAppend;

    $n =~ tr/ /_/;

    my $thisnoder .= $nameLink . $flags;

    #Votes only get refreshed when user logs in
    my $activedays = $userVars -> {votesrefreshed};

    # Gotta resort the noderlist by recent writeups and XP
    push @noderlist, {
        'noder' => $thisnoder
        , 'lastNodeTime' => $lastnodetime
        , 'activeDays' => $activedays
        , 'roomId' => $$U{room_id}
     };
  }
  $csr->finish;

  return '<em>There are no noders in this room.</em>' unless $num;
  # sort by latest time of noding, tie-break by active days if
  # necessary, [alex]'s idea

  @noderlist = sort {
    ($$b{roomId} == $$USER{in_room}) <=> ($$a{roomId} == $$USER{in_room})
    || $$b{roomId} <=> $$a{roomId}
    || $$b{lastNodeTime} <=> $$a{lastNodeTime}
    || $$b{activeDays} <=> $$a{activeDays}
  } @noderlist;

  my $printRoomHeader = sub {
     my $roomId = shift;
     my $roomTitle = 'Outside';
     if ($roomId != 0)
     {
       my $room = getNodeById($roomId);
       $roomTitle = $room && $$room{type}{title} eq 'room' ?
                        $$room{title} : 'Unknown Room';
     }
     return "<div>$roomTitle:</div>\n<ul>\n";
  };

  my $lastroom = $noderlist[0]->{roomId};
  $str .= "<ul>\n";
  foreach my $noder(@noderlist)
  {
    if ($$noder{roomId} != $lastroom)
    {
      $str .= "</ul>\n";
      $str .= &$printRoomHeader($$noder{roomId});
    }

    $lastroom = $$noder{roomId};
    $str .= "<li>$$noder{noder}</li>\n";
  }

  $str .= "</ul>\n";

  my $intro = '<h4>Your fellow users ('.$num.'):</h4>';
  $intro .= '<div>in '.linkNode($$USER{in_room}). ':</div>' if $$USER{in_room};

  return $intro . $str;

}

sub sign_in
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;

  my $str = "";

  if ($APP->isGuest($USER)) {
    $str.= htmlcode('minilogin');
  }else{
    $str.= "You are logged in.";
  }

  $str .= qq|<p>Need help? <a href="mailto:accounthelp\@everything2.com">accounthelp\@everything2.com</a></p>|;

  return $str;
}

sub recommended_reading
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;

  my $str='';
  $str.='<h4>'.linkNode(getNode('An Introduction to Everything2','e2node'), 'About Everything2').'</h4>';
  $str.='<h4>'.linkNode(getNode('Cool Archive','superdoc'), 'User Picks').'</h4>';
  $str.='<ul class="infolist">';
  my $coolnodes = $DB->stashData("coolnodes");
  my $count = 0;
  my $seen = {};

  while($count < 6 and @$coolnodes > 0){
    my $cw = shift @$coolnodes;
    next if $seen->{$cw->{coolwriteups_id}};
    $seen->{$cw->{coolwriteups_id}} = 1;

    my $N = $DB->getNodeById($cw->{coolwriteups_id});
    next unless $N;
    $str .= "<li>".linkNode($N, $cw->{parentTitle}, {lastnode_id => 0})."</li>";
    $count++;
  }

  $str.='</ul>';

  my $staffpicks = $DB->stashData("staffpicks");

  # From [rtnsection_edc]
  $str.= '<h4>'.linkNode(getNode('Page of Cool','superdoc'), 'Editor Picks').'</h4>';

  $str.= '<ul class="infolist">';

  for(1..6)
  {
    my $edpick = shift @$staffpicks;
    my $N = getNodeById(@$staffpicks);
    next unless $N;
    $str .= "<li>".linkNode($N,'',{lastnode_id => 0})."</li>";
  }

  $str.='</ul>';
  return $str;
}

sub vitals
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;

  my $str='';
  if (!$APP->isGuest($USER) )
  {
    $str.=htmlcode('nodeletsection','vit','maintenance','Maintenance');
  }

  $str .= htmlcode("nodeletsection","vit","nodeinfo","Noding Information");
  $str .= htmlcode("nodeletsection","vit","nodeutil","Noding Utilities");
  $str .= htmlcode("nodeletsection","vit","list","Lists");
  $str .= htmlcode("nodeletsection","vit","misc","Miscellaneous");

  return $str;
}

sub chatterbox
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;

  my $str='';

  $str .= htmlcode("openform2","formcbox");

  # get settings here in case they are being updated. Slight kludge to remember them...
  $PAGELOAD->{chatterboxsettingswidgetlink} = htmlcode('nodeletsettingswidget','Chatterbox', 'Chatterbox settings');
  unless($$VARS{hideprivmessages})
  {

    my $messagesID = getNode('Messages', 'nodelet') -> { node_id } ;
    unless($$VARS{ nodelets } =~ /\b$messagesID\b/)
    {

      my $msgstr = htmlcode('showmessages','10');
      my $hr .= '<hr width="40%">' if $msgstr;
      $str .= qq|<div id="chatterbox_messages">$msgstr</div>$hr|;
    }
  }

  $str .= qq|<div id='chatterbox_chatter'>|.htmlcode("showchatter").qq|</div><a name='chatbox'></a>|;

  unless($APP->isGuest($USER))
  {
    my $msgstr = '<input type="hidden" name="op" value="message" /><br />'."\n\t\t";
    $query->param('message','');

    #show what was said
    if(defined $query->param('sentmessage'))
    {
      my $told = $query->param('sentmessage');
      my $i=0;
      while(defined $query->param('sentmessage'.$i))
      {
        $told.="<br />\n\t\t".$query->param('sentmessage'.$i);
        ++$i;
      }
      $told=parseLinks($told,0) unless $$VARS{showRawPrivateMsg};
      $msgstr.="\n\t\t".'<p class="sentmessage">'.$told."</p>\n";
    }

    #borged or allow talk
    $msgstr .= htmlcode('borgcheck');
    $msgstr .= $$VARS{borged}
    ? '<small>You\'re borged, so you can\'t talk right now.</small><br>' . $query->submit('message_send', 'erase')
    : "<input type='text' id='message' name='message' class='expandable' size='".($$NODE{title} eq "ajax chatterlight" ? "70" : "12")."' maxlength='512'>" . "\n\t\t" .
    $query->submit(-name=>'message_send', id=>'message_send', value=>'talk'). "\n\t\t";
;

    if ($APP->isSuspended($USER,"chat"))
    {
      my $canMsg = ($$VARS{borged}
                ? "chatting."
                : "public chat, but you can /msg other users.");
      $msgstr .= "<p><small>You are currently suspended from $canMsg</small></p>\n"
    }

    $msgstr.=$query->end_form;

    $msgstr .= "\n\t\t".'<div align="center"><small>'.linkNodeTitle('Chatterbox|How does this work?')." | ".linkNodeTitle('Chatterlight')."</small></div>\n" if $APP->getLevel($USER)<2;

    #Jay's topic stuff

    my $topicsetting = "";
    my $topic = '';

    unless($$VARS{hideTopic} )
    {
      $topicsetting = getVars(getNode('Room Topics', 'setting'));

      if(exists($$topicsetting{$$USER{in_room}}))
      {
        $topic = $$topicsetting{$$USER{in_room}};
        utf8::decode($topic);
        $topic = "\n\t\t".'<small>'.parseLinks($topic).'</small>'; #slighly different
      }

    }

    $str.=$msgstr.$topic;
  }

  $str .= qq|<div class="nodeletfoot">|;

  if($APP->isChanop($USER))
  {
    $str .= linkNode($NODE, 'silence', {'confirmop' => 'flushcbox',
	-class=>"action ajax chatterbox:updateNodelet:Chatterbox"}).'<br>';
  }

  if($USER->{in_room})
  {
    $str .= linkNodeTitle('go outside[superdocnolinks]').'<br>';
  }
  
  $str .= $PAGELOAD->{chatterboxsettingswidgetlink}. qq|</div>|;
  return $str;
}

sub personal_links
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;

  my $str='';

  return 'You must log in first.' if $APP->isGuest($USER);

  # do this here to update settings before showing nodelet:
  my $settingslink = htmlcode('nodeletsettingswidget','Personal Links', 'Edit link list');

  my $limit=50;

  my $UID = getId($USER) || 0;
  if( $APP->isEditor($USER) ) {
	$limit += 20;
  }
  my @nodes = split('<br>',$$VARS{personal_nodelet});
  if (my $n = $query->param('addpersonalnodelet'))
  {
    return "<b>Security Error</b>" unless htmlcode('verifyRequest', 'personalnodelet');
    $n = getNodeById $n;
    if ($$VARS{personal_nodelet} !~ /$$n{title}/)
    {
      $$VARS{personal_nodelet} .= '<br>'.$$n{title} if @nodes < $limit;
      push @nodes, $$n{title};
    }
  }

  $str .= '<ul class="linklist">' ;
  my $i=0;
  foreach(@nodes)
  {
    next unless $_;
    $str.= "\n<li>".linkNodeTitle($_)."</li>";
    last if $i++ >= $limit;
  }

  $str .= "\n</ul>\n" ;

  my $t = $$NODE{title};
  $t =~ s/(\S{16})/$1 /g;

  $str .= '<div class="nodeletfoot">' ;
  $str .= linkNode($NODE, "add \"$t\"", {-class => 'action',
	-title => 'Add this node to your personal nodelet list. This list can be edited in Nodelet Settings',
	addpersonalnodelet => $$NODE{node_id}, %{htmlcode('verifyRequestHash', 'personalnodelet')}} ).'<br>'
	if @nodes < $limit ;

  $str .= $settingslink . '</div>';

  if($APP->isAdmin($USER))
  {
    $str .= '<hr width="100" /><small><strong>node bucket</strong></small><br>';
    my $PARAMS = { op => 'addbucket', 'bnode_' . $$NODE{node_id} => 1, -class=>'action' };
    my $t = $$NODE{title};
    $t =~ s/(\S{16})/$1 /g;
    $str .= linkNode($NODE, "Add '$t'", $PARAMS);

    my @bnodes = ();
    @bnodes = split ',', $$VARS{nodebucket} if (defined($$VARS{nodebucket}));
    my $isGroup = 0;
    $isGroup = 1 if $$NODE{type}{grouptable};

    if(scalar(@bnodes) == 0)
    {
      $str.="<p>Empty<br>\n";
    }else{
      $str.= htmlcode('openform');
      $str.=$query->hidden(-name => "op", -value => 'bucketop', force=>1);

      my $ajax = '&op=/';
      my @newbnodes;
      foreach my $id (@bnodes)
      {
        my $node=getNodeById($id);
        next unless $node;
        push @newbnodes, $id;
        # Can't use CGI::checkbox here because it insists on having a label...
        $str .= qq'<input type="checkbox" name="bnode_$$node{node_id}" value="1">'.
  	  linkNode($node, undef, {lastnode_id => undef}) . "<br>\n";
        $ajax .= "&bnode_$$node{node_id}=/";
      }

      $str .= "<input type='checkbox' name='dropexec' value='1' checked='checked'>" . "Execute and drop<br>\n" if($isGroup);

      if($isGroup)
      {
	$str .= $query->submit( -name => "bgroupadd", -value => "Add to Group",
		-class => "ajax personallinks:updateNodelet?bgroupadd=1$ajax:Personal+Links") ."\n";
      }

      $str .= $query->submit( -name => 'bdrop', -value => 'Drop',
		-class => "ajax personallinks:updateNodelet?bdrop=1$ajax:Personal+Links") . "\n";

      $VARS->{nodebucket} = join(",",@newbnodes);

      $str.='</form>';
    }
  }

  return $str;
}

sub random_nodes
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;


  my @choices = ('cousin','sibling','grandpa','grandma');
  my $r = $choices[rand(@choices)];
  my $rn = rand();
  my @phrase = (
	'Nodes your '.$r.' would have liked:',
	'After stirring Everything, these nodes rose to the top:',
	'Look at this mess the Death Borg made!',
	'Just another sprinkling of '.($rn<0.5?'indeterminacy':'randomness'),
	'The '.($rn<0.5?'best':'worst').' nodes of all time:',
	($rn<0.5?'Drink up!':'Food for thought:'),
	'Things you could have written:',
	'What you are reading:',
	'Read this. You know you want to:',
	'Nodes to '.($rn<0.5?'live by':'die for').':',
	'Little presents from the Node Fairy:',
  );

  my $randomnodes = $DB->stashData("randomnodes");

  my $str = "";
  $str.='<em>'.$phrase[rand(int(@phrase))]."</em>\n<ul class=\"linklist\">\n" ;

  my $len = 20;
  foreach my $N (@$randomnodes)
  { 
    my $RN = getNodeById( $N->{node_id} );
    my $node_title = $$RN{'title'};
    $node_title =~ s/(\S{$len})\S{4,}/$1.../go;
    $str .= '<li>' . linkNode($RN, $node_title, {lastnode_id=>0}) . "</li>\n";
  }
  $str .= "</ul>\n" ;

  return $str;
}

sub tips
{
  my $DB = shift;
  my $query = shift;
  my $NODE = shift;
  my $USER = shift;
  my $VARS = shift;
  my $PAGELOAD = shift;
  my $APP = shift;

  my $str = "";
  $str .= qq|<hr width=%70>|;

  my @tips = ("[Avoid highly subjective writeups]",
   "[Earn Your Bullshit]",
   "[Please use plain text]",
   "[Link and Link]",
   "[Integrate Your Write-Ups]",
   "[Don't Namespace Your Lyrics]",
   "[Pick Titles Carefully]",
   "[Please Attribute Anything You Quote]",
   "[Cut-and-Paste Writeups Will Die]",
   "(Here's) [How to Format Poems and Simple HTML]",
   "[Node For The Ages]");

  $str .= "<p align=center>".$tips[rand(int(@tips))].qq|<hr width=%70>|;

  return $str."TESTING";
}

1;