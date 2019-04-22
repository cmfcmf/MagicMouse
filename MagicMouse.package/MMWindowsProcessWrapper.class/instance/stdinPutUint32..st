as yet unclassified
stdinPutUint32: anInteger
	self stdinPutBuffer: {
		(anInteger digitAt: 4). 
		(anInteger digitAt: 3). 
		(anInteger digitAt: 2). 
		(anInteger digitAt: 1)}