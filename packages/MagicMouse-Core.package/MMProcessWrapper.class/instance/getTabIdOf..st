accessing
getTabIdOf: aMMBrowserMorph

	self browserMorphMapping keysAndValuesDo: [:tabId :aMMBrowserMorphInstance | aMMBrowserMorphInstance = aMMBrowserMorph ifTrue: [^ tabId]].
	Error signal: 'Given browser moprh is not registered for this process wrapper.'