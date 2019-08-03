instance creation
searchFor: aString

	| model |
	model := self new.
	ToolBuilder open: model.
	model searchFor: aString