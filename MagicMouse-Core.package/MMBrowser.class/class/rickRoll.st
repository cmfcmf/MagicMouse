as yet unclassified
rickRoll

	| model instance |
	model := self new.
	model locationText: 'https://www.youtube.com/embed/DLzxrzFCyOs?autoplay=1&loop=1&controls=0&modestbranding=1&showinfo=0'.
	instance := ToolBuilder open: model.
	model fullscreen: true.
	^ instance