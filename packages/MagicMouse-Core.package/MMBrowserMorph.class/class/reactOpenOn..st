instance creation
reactOpenOn: aUrl

	^ self new
		connect: aUrl throwTimeoutError: false;
		viewportSize: 250@80;
		yourself