events
mouseDown: anEvent

	| pos |
	pos := anEvent position - self position.
	self
		send: #mouseMove withDouble: pos x andDouble: pos y;
		send: #mouseDown.
	
	self grabKeyboard