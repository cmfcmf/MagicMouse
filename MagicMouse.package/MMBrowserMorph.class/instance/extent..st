as yet unclassified
extent: aPoint

.	viewportSize ~= aPoint ifTrue: [self send: #resize withDouble: aPoint x andDouble: aPoint y].
	
	viewportSize := aPoint.
	super extent: aPoint