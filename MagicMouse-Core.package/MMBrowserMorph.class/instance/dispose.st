as yet unclassified
dispose
	process ifNotNil: [:p | p terminate].
	imageUpdaterProcess ifNotNil: [:p | p terminate]