building
buildWith: aBuilder

	^ aBuilder build: (aBuilder pluggableWindowSpec new
		label: MMBrowserMorph title;
		extent: 600 @ 400;
		model: self;
		children: {
			aBuilder pluggablePanelSpec new
				wantsResizeHandles: true;
				frame: (LayoutFrame fractions: (0 @ 0 extent: 1 @ 0) offsets: (0 @ 0 extent: 0 @ 25));
				children: (self buildTopBarWith: aBuilder);
				yourself.
			aBuilder pluggablePanelSpec new
				frame: (LayoutFrame fractions: (0 @ 0 extent: 1 @ 0) offsets: (0 @ 25 extent: 0 @ 25));
				layout: #horizontal;
				children: (self buildButtonBarWith: aBuilder);
				yourself.
			aBuilder pluggablePanelSpec new
				wantsResizeHandles: true;
				frame: (LayoutFrame fractions: (0 @ 0 extent: 1 @ 1) offsets: (0 @ 50 extent: 0 @ -50));
				spacing: 5;
				children: {
					aBuilder pluggablePanelSpec new
						model: self;
						frame: (0 @ 0 extent: 0.8 @ 1);
						children: #getBrowserMorph;
						yourself.
					aBuilder pluggableListSpec new
						model: self;
						frame: (0.8 @ 0 corner: 1 @ 1);
						list: #extractedObjects;
						doubleClick: #exploreExtractedObject;
						getSelected: #selectedExtractedObject;
						setSelected: #selectedExtractedObject:;
						dragItem: #dragExtractedObject:;
						yourself};
				yourself};
		yourself)