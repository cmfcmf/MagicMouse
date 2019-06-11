as yet unclassified
structuredDataChanged: data

	self extractedObjects: (data collect: [:each | | d |
		d := DomainObject new delete.
		each associationsDo: [:assoc | 
			d perform: assoc key asLegalSelector asSymbol asMutator with: assoc value].
		d])