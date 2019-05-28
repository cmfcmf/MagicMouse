as yet unclassified
buildWith: aBuilder
	
	 ^ aBuilder build: (aBuilder pluggableWindowSpec new
			label: 'MagicMouse Browser';
			extent: 600@400;
			model: self;
			children: {
				aBuilder pluggablePanelSpec new
					wantsResizeHandles: true;
					frame: (LayoutFrame fractions: (0@0 extent: 1@0));
					children: {
						aBuilder pluggableTextSpec new 
							model: self;
							hardLineWrap: false;
							softLineWrap: false;
							getText: #locationText;
							setText: #changeLocation:;
							askBeforeDiscardingEdits: false;
							frame: (LayoutFrame fractions: (0@0 extent: 0.8@1));
							yourself.
						aBuilder pluggableTextSpec new 
							model: self;
							hardLineWrap: false;
							softLineWrap: false;
							getText: #searchText;
							setText: #searchFor:;
							askBeforeDiscardingEdits: false;
							frame: (LayoutFrame fractions: (0.8@0 extent: 0.2@1));
							yourself.
					};
					yourself.
				aBuilder pluggablePanelSpec new
					model: self;
					name: 'browserPanel';
					frame: (LayoutFrame fractions: (0@0 extent: 1@1) offsets: ((0@25) extent: (0@ -25)));
					children: #getBrowserMorph;
					margin: 20;
					yourself.
			};
			yourself)