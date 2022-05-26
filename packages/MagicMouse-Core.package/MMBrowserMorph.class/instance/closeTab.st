-> to chrome
closeTab

	self tabId ifNotNil: [MMProcessWrapper getOSDependentSingleton closeTab: self tabId]