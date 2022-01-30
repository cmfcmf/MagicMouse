building
buildButtonBarWith: aBuilder

	^ {
		aBuilder pluggableButtonSpec new
			model: self;
			action: #showBookmarks;
			label: 'Bookmarks';
			yourself.
		aBuilder pluggableButtonSpec new
			model: self;
			action: [PreferenceBrowser open selectedCategory: #MagicMouse];
			label: 'Preferences';
			yourself}