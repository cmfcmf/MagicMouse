stdin
stdinPutBuffer: aBuffer

	aBuffer ifNotEmpty: [
		stdinWriter
			nextPutAll: aBuffer;
			flush]