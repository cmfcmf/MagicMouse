accessing
getTabIdOf: aMMBrowserMorph

	

	self browserMorphMapping keysAndValuesDo: [:tabId :aMMBrowserMorphInstance |  aMMBrowserMorphInstance = aMMBrowserMorph ifTrue: [^tabId]].
	self halt.