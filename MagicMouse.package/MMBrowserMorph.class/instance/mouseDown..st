events
mouseDown: anEvent
	anEvent yellowButtonChanged ifTrue: [ "right click"
		self sendEvent: #halo withPoint: anEvent position - self position
	] ifFalse: [ "left click"
		self
			sendEvent: #mouseMove withPoint: anEvent position - self position;
			sendEvent: #mouseDown.
		self activeHand keyboardFocus == self ifTrue: [^ self].
		self activeHand newKeyboardFocus: self]