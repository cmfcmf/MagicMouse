as yet unclassified
dragExtractedObject: aNumber

	| domainObject |
	domainObject := extractedObjects at: aNumber.
	domainObject undelete.

	^ domainObject