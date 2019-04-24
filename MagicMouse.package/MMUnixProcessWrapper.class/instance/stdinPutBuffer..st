as yet unclassified
stdinPutBuffer: aBuffer
	aBuffer ifNotEmpty: [stdinWriter nextPutAll: aBuffer; flush]