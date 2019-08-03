<- from chrome
refreshPortals: portalInfos

	self portalMorphs keysAndValuesDo: [:id :morph | | isMyChild isOnPage |
		isMyChild := morph owner = self.
		isOnPage := portalInfos anySatisfy: [:each | id = each first].		
		(isMyChild and: [isOnPage not]) ifTrue: [morph delete].
		(isMyChild not or: [isOnPage not]) ifTrue: [self portalMorphs removeKey: id]]