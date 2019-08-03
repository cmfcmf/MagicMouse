domain objects
domainObjectFieldFor: aString object: aDomainObject

	| fields |
	fields := self possibleDomainObjectFieldsFor: aString.
	fields do: [:each |
		(aDomainObject respondsTo: each) ifTrue: [^ each]].
	^ #unknown.