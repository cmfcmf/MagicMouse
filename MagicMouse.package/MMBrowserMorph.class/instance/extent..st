geometry
extent: aPoint
	viewportSize ~= aPoint ifTrue: [self sendEvent: #resize withPoint: aPoint].
	
	viewportSize := aPoint.
	super extent: aPoint