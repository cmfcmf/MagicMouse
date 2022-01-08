connecting
connect: aUrl
	
	self tabId: (MMProcessWrapper getOSDependentSingleton lauchNewPageAt: aUrl withExtend: self viewportSize x @ self viewportSize y for: self).
	location := aUrl.