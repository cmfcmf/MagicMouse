domain objects
nameFromDomainObject: aDomainObject

	| name |
	name := aDomainObject ? #fullName.
	name ifNil: [ | firstName lastName |
		firstName := aDomainObject ? #firstName.
		lastName := aDomainObject ? #lastName.
		(firstName notNil and: [lastName notNil]) ifTrue: [
			name := '{1} {2}' format: {firstName. lastName}]].
	"name ifNil: [name := aDomainObject ? #name]."
 	name ifNil: [name := aDomainObject ? #title].
 	name ifNil: [name := aDomainObject ? #headline].
 	name ifNil: [name := aDomainObject ? #content].
 	name ifNil: [name := aDomainObject ? #description].
	
	^ name