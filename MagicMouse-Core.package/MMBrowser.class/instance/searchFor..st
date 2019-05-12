as yet unclassified
searchFor: aText
	| search |
	search := aText asString.
	self searchText: search.
	self flag: #fixme. "The search parameter needs to be encoded (e.g., it might contain &)"
	self changeLocation: 'https://www.google.com/search?q=', search