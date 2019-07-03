building
buildTopBarWith: aBuilder

	^ {
		aBuilder pluggableButtonSpec new
			frame: ((LayoutFrame fractions: (0@0 extent: 0@1))
				rightOffset: 25;
				yourself);
			model: self;
			help: 'back';
			action: [browser goBack];
			label: '<';
			yourself.
		aBuilder pluggableButtonSpec new
			frame: ((LayoutFrame fractions: (0@0 extent: 0@1))
				leftOffset: 25;
				rightOffset: 50;
				yourself);
			model: self;
			help: 'forward';
			action: [browser goForward];
			label: '>';
			yourself.
		aBuilder pluggableInputFieldSpec new 
			model: self;
			hardLineWrap: false;
			softLineWrap: false;
			getText: #locationText;
			setText: #changeLocation:;
			askBeforeDiscardingEdits: false;
			frame: ((LayoutFrame fractions: (0@0 extent: 0.8@1))
				leftOffset: 50;
				rightOffset: -25;
				yourself);
			yourself.
		aBuilder pluggableButtonSpec new
			frame: ((LayoutFrame fractions: (0.8@0 corner: 0.8@1))
				leftOffset: -25;
				yourself);
			model: self;
			label: 'o';
			action: [browser doRefresh];
			help: 'location';
			yourself.
		aBuilder pluggableInputFieldSpec new 
			model: self;
			hardLineWrap: false;
			softLineWrap: false;
			getText: #searchText;
			setText: #searchFor:;
			askBeforeDiscardingEdits: false;
			help: 'search';
			frame: (LayoutFrame fractions: (0.8@0 extent: 0.2@1));
			yourself}