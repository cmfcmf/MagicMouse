events
keyStroke: anEvent

	self send: #keyPress withString: (self translateKeyEvent: anEvent)