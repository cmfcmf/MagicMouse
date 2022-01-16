instance creation
mmCleanUp

	| currentSingleton |
	currentSingleton := self getOSDependentSingleton.
	currentSingleton isRunning: false.
	currentSingleton process ifNotNil: [currentSingleton terminate].
	MMBrowserMorph allInstancesDo: [:inst | inst abandon].
	self renewOSDependentSingleton.
	currentSingleton reactToNodeOutputProcess ifNotNil: [:process | process terminate]