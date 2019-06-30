as yet unclassified
buildWith: aBuilder
	
	 ^ aBuilder build: (aBuilder pluggableWindowSpec new
			label: MMBrowserMorph title;
			extent: 600@400;
			model: self;
			children: {
				aBuilder pluggablePanelSpec new
					wantsResizeHandles: true;
					frame: (LayoutFrame fractions: (0@0 extent: 1@0) offsets: ((0@0) extent: (0@ 25)));
					children: {
						aBuilder pluggableInputFieldSpec new 
							model: self;
							getText: #locationText;
							setText: #changeLocation:;
							askBeforeDiscardingEdits: false;
							frame: (LayoutFrame fractions: (0@0 extent: 0.8@1));
							yourself.
						aBuilder pluggableInputFieldSpec new 
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
					frame: (LayoutFrame fractions: (0@0 extent: 1@1) 
						offsets: ((0@25) extent: (0@ -25)));
					spacing: 5;
					children: {
						aBuilder pluggablePanelSpec new
							model: self;
							frame: (0@0 extent: 0.8@1);
							children: #getBrowserMorph;
							yourself.
						aBuilder pluggableListSpec new
							model: self;
							frame: (0.8@0 corner: 1@1);
							list: #extractedObjects;
							doubleClick: #exploreExtractedObject;
							getSelected: #selectedExtractedObject;
							setSelected: #selectedExtractedObject:;
							dragItem: #dragExtractedObject:;
							yourself
					};
					yourself.
			};
			yourself)