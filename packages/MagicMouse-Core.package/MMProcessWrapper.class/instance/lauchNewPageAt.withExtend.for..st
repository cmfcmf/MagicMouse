stdin
lauchNewPageAt: aUrl withExtend: aPoint for: aMMBrowserMorph

	
	self isRunning 
		ifTrue: [self halt. ^self openNewTabAt: aUrl withExtend: aPoint for: aMMBrowserMorph]
		ifFalse: [^self startProcessWithLocation: aUrl withExtend: aPoint for: aMMBrowserMorph]