events
mouseDown: anEvent
	| position |
	position := (anEvent position - self position) max: 0@0.
	anEvent yellowButtonChanged ifTrue: [ "right click"
		self sendEvent: #halo withPoint: position
	] ifFalse: [ "left click"
		self
			sendEvent: #mouseMove withPoint: position;
			sendEvent: #mouseDown.
		self activeHand keyboardFocus == self ifTrue: [^ self].
		self activeHand newKeyboardFocus: self]