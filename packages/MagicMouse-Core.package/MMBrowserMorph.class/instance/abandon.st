accessing
abandon


	self tabId ifNotNil: [MMProcessWrapper getOSDependentSingleton closeTab: self tabId].
	super abandon