events
mouseWheel: anEvent
	self sendEvent: #mouseWheel withNumber: (anEvent isWheelUp ifTrue: [0] ifFalse: [1]).
	"The following code moves all submorphs - but this should only be done for things that actually move when the page is scrolled"
	"self submorphsDo: [:each | each position: (each position translateBy: 0@(anEvent isWheelUp ifTrue: [20] ifFalse: [-20]))]"