as yet unclassified
searchFor: aString

	self flag: #fixme. "The search parameter needs to be encoded (e.g., it might contain &)"
	self changeLocation: 'https://www.google.com/search?q=', aString