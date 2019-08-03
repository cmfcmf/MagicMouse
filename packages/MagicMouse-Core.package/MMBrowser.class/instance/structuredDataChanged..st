extracted objects
structuredDataChanged: data

	| objects |
	objects := (data collect: [:each | | object |
		object := DomainObject new delete.
		each associationsDo: [:assoc | | field |
			field := assoc key asLegalSelector asSymbol.
			field = #name ifTrue: [field := #title].
			object perform: field asMutator with: assoc value].
		object]).
	objects ifEmpty: [
		objects := {DomainObject new delete 
			title: self locationText asString;
			url: self locationText asString;
			yourself}].
	self extractedObjects: objects.