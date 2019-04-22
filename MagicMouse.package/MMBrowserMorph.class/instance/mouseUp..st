events
mouseUp: anEvent

	self
		sendEvent: #mouseMove withPoint: anEvent position - self position;
		sendEvent: #mouseUp