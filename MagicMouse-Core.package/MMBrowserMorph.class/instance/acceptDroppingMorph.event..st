as yet unclassified
acceptDroppingMorph: aMorph event: evt

	| domainObject |
	domainObject := aMorph passenger.
	
	(self urlFromDomainObject: domainObject) ifNotNil: [:url | ^ self changeLocation: url].
	(self nameFromDomainObject: domainObject) ifNotNil: [:name | ^ self searchFor: name]