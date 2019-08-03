events
mouseUp: anEvent

	| position |
	position := (anEvent position - self position) max: 0@0.
	self
		sendEvent: #mouseMove withPoint: position;
		sendEvent: (anEvent yellowButtonChanged ifTrue: [#mouseRightUp] ifFalse: [#mouseLeftUp])