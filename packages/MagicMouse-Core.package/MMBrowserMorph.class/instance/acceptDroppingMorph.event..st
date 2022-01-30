dropping/grabbing
acceptDroppingMorph: aMorph event: evt

	| position target |
	position := evt position - self position.
	target := (aMorph isKindOf: TransferMorph)
		ifTrue: [
			aMorph passenger isText
				ifTrue: [aMorph passenger asString]
				ifFalse: [aMorph passenger]]
		ifFalse: [
			(aMorph isSystemWindow and: [aMorph model isKindOf: StringHolder])
				ifTrue: [aMorph model contents asString]
				ifFalse: [aMorph]].
	
	(Smalltalk classNamed: #DomainObject) ifNotNil: [:domainObject | (target isKindOf: domainObject) ifTrue: [self droppedDomainObject: target at: position]].
	
	target isString ifTrue: [self droppedString: target at: position]