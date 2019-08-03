public
searchFor: aText

	| search |
	search := aText asString.
	self searchText: search.
	browser searchFor: search