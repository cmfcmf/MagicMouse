as yet unclassified
updateImage: aStream

	| len png |
	len := aStream uint32.
	png := aStream next: len.
	self image: (Form fromBinaryStream: png asByteArray readStream).