instance creation
shutDown: ignored

	| currentSingleton |
	currentSingleton := self getOSDependentSingleton.
	currentSingleton isRunning: false.
	currentSingleton process ifNotNil: [currentSingleton terminate].
	self renewOSDependentSingleton.
	currentSingleton reactToNodeOutputProcess ifNotNil: [:process | process terminate].
	Transcript showln: 'killed browser wrapper'.
	
	super shutDown: ignored