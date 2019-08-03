<- from chrome
movePortal: id rect: rect

	self portalMorphs at: id ifPresent: [:morph |
		morph
			position: self position + rect origin;
			extent: rect extent]