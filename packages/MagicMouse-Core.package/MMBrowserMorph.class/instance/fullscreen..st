public
fullscreen: aBoolean

	aBoolean
		ifTrue: [previousOwner := self owner.
			self
				beSticky;
				openInWorld: self world;
				extent: self world extent;
				position: 0@0]
		ifFalse: [
			self beUnsticky.
			previousOwner addMorph: self.
			previousOwner := nil]