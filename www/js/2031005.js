// 2031005.js - frommage
// Unknown usage

// text formatting aids
e2.add(function(inElement){
	// activate tinyMCE if preferred, otherwise JS QuickTags,
	// and provide switch to toggle to the other

	var aids = {
		initial: (e2.settings_useTinyMCE ? 'WYSIWYG editor' : 'HTML toolbar'),
		active: {},

		'HTML toolbar': {
			library: '/node/rawdata/HTMLToolbar?displaytype=raw',
			test: 'edToolbar',

			stop: function(id){
				$('#' + 'ed_toolbar_' + id).slideUp(e2.fxDuration);
			},

			go: function(id){
				if (!$('#' + 'ed_toolbar_' + id).length){
					e2.divertWrite(null); // save it up until finished
					edToolbar(id);
					e2.divertWrite($('#'+id)[0]);
				}
				$('#' + 'ed_toolbar_' + id).hide().slideDown(e2.fxDuration);
			}
		},

		'WYSIWYG editor': {
			library: 'http://james.crompton.eu/tiny_mce/tiny_mce.js',
			test: 'tinyMCE',

			stop: function(id){
				tinyMCE.execCommand('mceToggleEditor', false, id)
			},

			go: function(id){
				if (!aids['WYSIWYG editor'].initted){
					tinymce.dom.Event.domLoaded = true; // Hah!
					tinyMCE.init($.extend(e2.tinyMCESettings,{
						mode: 'exact',
						elements: id,
						theme_advanced_resizing : true
    				}));
    				aids['WYSIWYG editor'].initted = true;
					return;
				}else if (tinyMCE.getInstanceById(id)){
					tinyMCE.execCommand('mceToggleEditor', false, id);
		  		}else{
					tinyMCE.execCommand('mceAddControl', false, id);
				}
			}
		}
	};

	function toggle(e){
		e.preventDefault();
		var id = this.targetId;
		var $this = $(this);
		var active = aids.active[id] || aids.initial;
		var other = 'WYSIWYG editorHTML toolbar'.replace(active, '');

		$this.addClass('pending');
		e2.doWithLibrary(aids[other].library, aids[other].test, doToggle, function(){
			alert('Ack! Failed to load library for ' + other + '.');});

		function doToggle(){
			$this.removeClass('pending');
			// next two async so any errors don't stop us. Not try/catch so they hit console
			try{ aids[other].go(id); }catch(e){}
			try{ aids[active].stop(id); }catch(e){}
			$this.find('span').text('offon'.replace($this.find('span').text(), ''));
			aids.active[id] = other;
		}
	}

	$(inElement + ' .fromattable').each(function(){
		if (!this.id) this.id = e2.getUniqueId();
		var id = this.id;
		e2.doWithLibrary(aids[ aids.initial ].library, aids[ aids.initial ].test,
			function(){aids[ aids.initial ].go(id);});

		$('<p><button type="button" id="' + this.id + '_switch" href="#">Turn <span>'+
			(e2.settings_useTinyMCE ? 'off' : 'on') +
			'</span> <abbr title="What you see is what you get">WYSIWYG</abbr> '+
			'editing.</button></p>')
		.insertBefore(this)
		.find('button').click(toggle)
		[0].targetId = this.id;
 	});
});
