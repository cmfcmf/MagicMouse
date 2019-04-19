as yet unclassified
delete
	super delete.
	process ifNotNil: [:p |
		p closeStreams; sigterm].
	imageUpdaterProcess ifNotNil: [:p | p terminate]