extracted objects
dragExtractedObject: aNumber

	| domainObject |
	domainObject := extractedObjects at: aNumber.
	domainObject undelete.
	
	^ domainObject