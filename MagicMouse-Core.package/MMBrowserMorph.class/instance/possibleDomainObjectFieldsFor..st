as yet unclassified
possibleDomainObjectFieldsFor: aString

	| names separators |
	names := OrderedCollection new.
	names add: aString asCamelCase withFirstCharacterDownshifted asSymbol.
	
	separators := #(/ or , ;).
	separators do: [:separator |
		aString splitBy: separator do: [:each | 
			each ~= aString ifTrue: [names add: each asCamelCase withFirstCharacterDownshifted asSymbol]]].

	names addAll: (aString caseOf: {		
		['address line 1'] -> [#(street)]
	} otherwise: [#()]).
	
	^ names