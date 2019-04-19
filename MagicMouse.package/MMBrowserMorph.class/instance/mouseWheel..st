events
mouseWheel: anEvent

	self send: #mouseWheel withNumber: (anEvent isWheelUp ifTrue: [0] ifFalse: [1])