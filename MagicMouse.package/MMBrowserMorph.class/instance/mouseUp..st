events
mouseUp: anEvent

	self
		send: #mouseMove withPoint: anEvent position - self position;
		send: #mouseUp