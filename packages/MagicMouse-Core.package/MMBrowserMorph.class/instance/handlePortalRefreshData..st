<- from chrome
handlePortalRefreshData: payload

	| start portalInfos |
	self assert: [$r = (payload unsignedCharAt: 2)].
	start := 7.
	portalInfos := OrderedCollection new.
	(payload signedLongAt: 3) timesRepeat: [ | portalInfo rect |
		portalInfo := self getIdAndRectFrom: payload startAt: start.
		portalInfos add: portalInfo.
		start := portalInfo third].
	
	self refreshPortals: portalInfos.
	
	portalInfos do: [:each | | id rect |
		id := each first.
		rect := each second.
		self movePortal: id rect: rect]