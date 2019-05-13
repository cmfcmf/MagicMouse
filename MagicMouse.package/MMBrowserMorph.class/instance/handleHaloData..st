as yet unclassified
handleHaloData: payload
	(payload unsignedCharAt: 2) caseOf: {
		[$i] -> [self handleHaloImageData: payload].
		[$c] -> [self handleHaloCodeData: payload].
		[$r] -> [self handlePortalRefreshData: payload].
	}.