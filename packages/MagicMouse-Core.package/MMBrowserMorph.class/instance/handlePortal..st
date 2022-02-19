<- from chrome
handlePortal: payload

	(payload unsignedCharAt: 2) caseOf: {
		[$i] -> [self handlePortalImage: payload].
		[$m] -> [self handlePortalMorph: payload].
		[$c] -> [self handleCodePortal: payload].
		[$r] -> [self handlePortalRefreshData: payload]}