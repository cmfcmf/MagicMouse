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
	
	"Remove all portal morphs from our portalMorphs dictionary for which we didn't get any data. Additionally delete them only if they are still submorphs of mine."
	self portalMorphs keysAndValuesRemove: [:id :morph | | remove |
		remove := ((portalInfos anySatisfy: [:each | id = each first]) not) or: 
			[morph owner ~= self].
		(remove and: [morph owner = self]) ifTrue: [morph delete].
		remove].

	portalInfos do: [:each | | id rect | id := each first. rect := each second.
		self movePortal: id rect: rect].
	