as yet unclassified
stdinPutBuffer: aByteArray
	aByteArray ifNotEmpty: [self process writeToStdin: aByteArray]