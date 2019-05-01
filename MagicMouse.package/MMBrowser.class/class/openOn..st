as yet unclassified
openOn: aUrl
	| model |
	model := self new.
	model locationText: aUrl.
	^ ToolBuilder open: model