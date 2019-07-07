bookmarks
addOrRemoveBookmark

	| url |
	url := self locationText asString.
	Bookmarks remove: url ifAbsent: [Bookmarks add: url]