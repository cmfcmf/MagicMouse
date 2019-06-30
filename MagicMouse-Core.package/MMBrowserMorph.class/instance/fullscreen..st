as yet unclassified
fullscreen: aBoolean

	aBoolean
		ifTrue: [previousOwner := self owner.
			self
				openInWorld: self world;
				extent: self world extent;
				position: 0@0]
		ifFalse: [previousOwner addMorph: self.
			previousOwner := nil]