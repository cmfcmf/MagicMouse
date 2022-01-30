initialize-release
initialize

	super initialize.
	locationText := 'https://google.com'.
	searchText := ''.
	browser := MMBrowserMorph new.
	extractedObjects := OrderedCollection new