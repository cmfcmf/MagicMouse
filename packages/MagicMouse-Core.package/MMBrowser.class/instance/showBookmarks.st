bookmarks
showBookmarks

	| url |
	self bookmarks ifEmpty: [^ UIManager default inform: 'You have not created any bookmarks yet.'].
	url := UIManager default chooseFrom: self bookmarks values: self bookmarks.
	url ifNil: [^ self].
	self changeLocation: url