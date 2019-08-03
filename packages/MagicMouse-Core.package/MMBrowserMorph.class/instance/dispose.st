disconnecting
dispose

	process ifNotNil: [:p | p terminate. process := nil].
	imageUpdaterProcess ifNotNil: [:p | p terminate. imageUpdaterProcess := nil]