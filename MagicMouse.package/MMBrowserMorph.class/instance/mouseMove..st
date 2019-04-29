events
mouseMove: anEvent
	| position |
	position := anEvent position - self position.
	position >= (0@0) ifTrue: [self sendEvent: #mouseMove withPoint: position]