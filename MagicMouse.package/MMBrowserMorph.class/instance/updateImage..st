as yet unclassified
updateImage: aStream

	| len png |
	len := aStream uint32.
	Transcript show: len.
	Transcript cr.
	png := aStream next: len.
	self image: (Form fromBinaryStream: png asByteArray readStream).