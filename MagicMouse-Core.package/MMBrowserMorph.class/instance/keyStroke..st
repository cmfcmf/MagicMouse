events
keyStroke: anEvent

	anEvent keyString = '<Cmd-l>'
		ifTrue: [self fullscreen: previousOwner isNil]
		ifFalse: [self sendEvent: #keyPress withString: anEvent keyString]