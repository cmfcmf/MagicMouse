as yet unclassified
searchFor: aString
	| model |
	model := self new.
	ToolBuilder open: model.
	model searchFor: aString