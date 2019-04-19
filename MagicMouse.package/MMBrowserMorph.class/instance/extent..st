as yet unclassified
extent: aPoint

	viewportSize ~= aPoint ifTrue: [self send: #resize withPoint: aPoint].
	
	viewportSize := aPoint.
	super extent: aPoint