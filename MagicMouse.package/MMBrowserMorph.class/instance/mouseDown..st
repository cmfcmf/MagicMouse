events
mouseDown: anEvent

	self
		send: #mouseMove withPoint: anEvent position - self position;
		send: #mouseDown.
	
	self activeHand keyboardFocus == self ifTrue: [^ self].
	self activeHand newKeyboardFocus: self