as yet unclassified
stdinPutUint8: anInteger

	| buffer |
	buffer := ByteArray new: 1.
	buffer byteAt: 1 put: anInteger.
	self stdinPutBuffer: buffer