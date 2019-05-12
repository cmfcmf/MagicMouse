as yet unclassified
stdinPutBuffer: aBuffer
	aBuffer ifNotEmpty: [self process writeToStdin: aBuffer asByteArray]