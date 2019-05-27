as yet unclassified
handlePortalRefreshData: payload
	| start portalInfos |
	self assert: [$r = (payload unsignedCharAt: 2)].
	start := 7.
	portalInfos := OrderedCollection new.
	(payload signedLongAt: 3) timesRepeat: [ | portalInfo rect |
		portalInfo := self getIdAndRectFrom: payload startAt: start.
		portalInfos add: portalInfo.
		start := portalInfo third].
	
	self portalMorphs keysAndValuesDo: [:id :morph | | isMyChild isOnPage |
		isMyChild := morph owner = self.
		isOnPage := portalInfos anySatisfy: [:each | id = each first].		
		(isMyChild and: [isOnPage not]) ifTrue: [morph delete].
		(isMyChild not or: [isOnPage not]) ifTrue: [self portalMorphs removeKey: id]].

	portalInfos do: [:each | | id rect | id := each first. rect := each second.
		self movePortal: id rect: rect].
	