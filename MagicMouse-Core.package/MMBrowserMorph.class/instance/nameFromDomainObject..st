as yet unclassified
nameFromDomainObject: aDomainObject

	| name |
	name := aDomainObject ? #fullName.
	name ifNil: [ | firstName lastName |
		firstName := aDomainObject ? #firstName.
		lastName := aDomainObject ? #lastName.
		(firstName notNil and: [lastName notNil]) ifTrue: [
			name := '{1} {2}' format: {firstName. lastName}]].
	^ name