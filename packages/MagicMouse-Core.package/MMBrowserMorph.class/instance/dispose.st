disconnecting
dispose

	imageUpdaterProcess ifNotNil: [:p |
		p terminate.
		imageUpdaterProcess := nil]