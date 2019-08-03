events
mouseDown: anEvent

	| position |
	position := (anEvent position - self position) max: 0@0.
	(self class portalsOnRightClick and: [anEvent yellowButtonChanged]) ifTrue: [
		self sendEvent: #portal withPoint: position
	] ifFalse: [
		self
			sendEvent: #mouseMove withPoint: position;
			sendEvent: (anEvent yellowButtonChanged ifTrue: [#mouseRightDown] ifFalse: [#mouseLeftDown]).
		self activeHand keyboardFocus == self ifTrue: [^ self].
		self activeHand newKeyboardFocus: self]