instance creation
mmCleanUp

	MMBrowserMorph allInstancesDo: [:inst | inst abandon].
	self getOSDependentSingleton terminate.
	self renewOSDependentSingleton