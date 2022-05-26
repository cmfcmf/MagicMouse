instance creation
renewOSDependentSingleton

	| currentSingleton |
	currentSingleton := self getOSDependentSingleton.
	currentSingleton isRunning: false.
	currentSingleton process ifNotNil: [currentSingleton terminate].
	MMBrowserMorph allInstancesDo: [:inst | inst abandon].
	OSDependentProcessSingleton := OSProcess isWindows
		ifTrue: [
			"Smalltalk platformSubtype = 'X64' 
			ifTrue: ["
			MMWindowsProcessWrapperFFI new
			"] 
			ifFalse: [MMWindowsProcessWrapperPW new]"]
		ifFalse: [MMUnixProcessWrapper new].
	currentSingleton reactToNodeOutputProcess ifNotNil: [:process | process terminate].
	^ OSDependentProcessSingleton