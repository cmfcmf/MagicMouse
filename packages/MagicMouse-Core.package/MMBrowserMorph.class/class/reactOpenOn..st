instance creation
reactOpenOn: aUrl

	^ self new
		viewportSize: 300 @ 300;
		connect: aUrl;
		changed;
		yourself