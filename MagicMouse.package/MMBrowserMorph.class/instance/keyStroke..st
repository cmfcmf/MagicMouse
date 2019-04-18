as yet unclassified
keyStroke: anEvent

	self send: #keyPress withString: (self translateKeyEvent: anEvent)