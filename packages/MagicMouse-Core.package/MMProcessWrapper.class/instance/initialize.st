initialize-release
initialize

	super initialize.
	debug := self class debugEnabled.
	self isRunning: false.
	self browserMorphMapping: Dictionary new