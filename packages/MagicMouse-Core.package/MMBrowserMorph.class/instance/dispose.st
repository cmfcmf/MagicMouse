disconnecting
dispose

	self closeTab.
	imageUpdaterProcess ifNotNil: [:p |
		p terminate.
		imageUpdaterProcess := nil]