instance creation
getOSDependentSingleton

	OSDependentProcessSingleton ifNil: [self renewOSDependentSingleton].
	^ OSDependentProcessSingleton