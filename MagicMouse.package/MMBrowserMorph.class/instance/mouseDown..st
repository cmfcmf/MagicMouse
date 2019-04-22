events
mouseDown: anEvent

	self
		sendEvent: #mouseMove withPoint: anEvent position - self position;
		sendEvent: #mouseDown.
	
	self activeHand keyboardFocus == self ifTrue: [^ self].
	self activeHand newKeyboardFocus: self