as yet unclassified
updateImage: aStream format: aCharacter

	| len png width height form |
	aCharacter = $r ifTrue: [
		width := aStream uint32.
		height := aStream uint32.
		len := width * height * 4.
		png := aStream next: len.
		form := Form extent: width@height depth: 32.
		1 to: (width * height - 1) do: [:index | form bits at: index put: (
			(((png at: index * 4 + 3) asInteger) <<   0) + 
			(((png at: index * 4 + 2) asInteger) <<   8) + 
			(((png at: index * 4 + 1) asInteger) << 16) + 
			(((png at: index * 4 + 0) asInteger) << 24)
		)]. 
		self image: form
	].
	aCharacter = $p ifTrue: [
		len := aStream uint32.
		png := aStream next: len.
		self image: (Form fromBinaryStream: png asByteArray readStream) ]