as yet unclassified
acceptDroppingMorph: aMorph event: evt

	| domainObject bytes position |
	domainObject := aMorph passenger.
	
	position := evt position - self position.
	bytes := ByteArray new: 8.
	bytes
		signedLongAt: 1 put: position x;
		signedLongAt: 5 put: position y.
	self sendCommand: $f withBuffer: bytes.
	tmpDomainObject := aMorph passenger.
	"(self urlFromDomainObject: domainObject) ifNotNil: [:url | ^ self changeLocation: url].
	(self nameFromDomainObject: domainObject) ifNotNil: [:name | ^ self searchFor: name]"