events
mouseMove: anEvent

	self sendEvent: #mouseMove withPoint: anEvent position - self position