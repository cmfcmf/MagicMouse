extracted objects
structuredDataChanged: data

	| objects domainObject |
	domainObject := Smalltalk classNamed: #DomainObject.
	domainObject ifNil: [^ self].
	
	objects := data collect: [:each | | object |
		object := domainObject new delete.
		each associationsDo: [:assoc | | field |
			field := assoc key asLegalSelector asSymbol.
			field = #name ifTrue: [field := #title].
			object perform: field asMutator with: assoc value].
		object].
	objects ifEmpty: [
		objects := {
			domainObject new delete
				title: self locationText asString;
				url: self locationText asString;
				yourself}].
	self extractedObjects: objects