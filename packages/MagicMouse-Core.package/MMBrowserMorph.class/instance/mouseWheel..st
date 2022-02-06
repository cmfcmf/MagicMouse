events
mouseWheel: anEvent

	| naturalScrollingDelta |
	naturalScrollingDelta := anEvent wheelDelta x @ anEvent wheelDelta y negated.
	self sendEvent: #mouseWheel withSignedPoint: naturalScrollingDelta