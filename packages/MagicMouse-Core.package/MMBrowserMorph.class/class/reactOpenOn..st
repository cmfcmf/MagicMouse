instance creation
reactOpenOn: aUrl

	^ self new
		connect: aUrl;
		viewportSize: 250@80;
		yourself