events
mouseWheel: anEvent

	self sendEvent: #mouseWheel withNumber: (anEvent isWheelUp ifTrue: [0] ifFalse: [1])