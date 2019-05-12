accessing
locationText: aText
	| url |
	url := aText asString.
	((url findString: 'https://') = 0 and: [(url findString: 'http://') = 0]) ifTrue: [
		url := 'https://', url].
	locationText := url.
	self changed: #locationText