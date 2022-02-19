dropping/grabbing
wantsDroppedMorph: aMorph event: evt

	(aMorph isKindOf: TransferMorph) ifTrue: [ | passenger |
		passenger := aMorph passenger.
		(Smalltalk classNamed: #DomainObject) ifNotNil: [:domainObject | (passenger isKindOf: domainObject) ifTrue: [^ true]].
		passenger isText ifTrue: [^ true]].
	
	(aMorph isSystemWindow and: [aMorph model isKindOf: Workspace]) ifTrue: [^ true].
	
	^ false