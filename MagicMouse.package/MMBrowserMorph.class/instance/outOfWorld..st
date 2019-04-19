as yet unclassified
outOfWorld: aWorld
	super outOfWorld: aWorld.
	
	process ifNotNil: [:p |
		p closeStreams; sigterm].
	imageUpdaterProcess ifNotNil: [:p | p terminate]