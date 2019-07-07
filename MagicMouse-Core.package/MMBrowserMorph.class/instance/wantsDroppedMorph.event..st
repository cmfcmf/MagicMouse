dropping/grabbing
wantsDroppedMorph: aMorph event: evt

	^ (Smalltalk classNamed: #DomainObject) 
		ifNil: [false] 
		ifNotNil: [:domainObject | aMorph class = (Smalltalk classNamed: #RTransferMorph) 
			and: [domainObject withAllSubclasses includes: aMorph passenger class]]