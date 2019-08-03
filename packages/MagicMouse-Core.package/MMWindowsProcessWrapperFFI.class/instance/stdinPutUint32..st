stdin
stdinPutUint32: anInteger

	| buffer |
	buffer := ByteArray new: 4.
	buffer byteAt: 1 put: (anInteger digitAt: 4).
	buffer byteAt: 2 put: (anInteger digitAt: 3).
	buffer byteAt: 3 put: (anInteger digitAt: 2).
	buffer byteAt: 4 put: (anInteger digitAt: 1).
	self stdinPutBuffer: buffer