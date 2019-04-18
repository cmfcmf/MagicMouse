as yet unclassified
delete

	super delete.
	running  := false.
	process ifNotNil: [:p |
		p closeStreams; sigterm]