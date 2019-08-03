geometry
extent: aPoint

	(viewportSize ~= aPoint and: [self isConnected])
		ifTrue: [self sendEvent: #resize withPoint: aPoint].
	
	viewportSize := aPoint.
	super extent: aPoint