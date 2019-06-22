as yet unclassified
readBuffer: aHandle length: anInteger

	| bytesRead buffer |
	buffer := ByteArray new: anInteger.
	
	bytesRead := CMFWinFFI makePointerOf: ExternalType ulong.
	CMFWinFFI noError: [CMFWinFFI readFile: (aHandle getHandle unsignedLongLongAt: 1) 
		buffer: buffer bytesToRead: anInteger bytesRead: bytesRead overlapped: nil].
	bytesRead := bytesRead getHandle unsignedLongAt: 1.
	self assert: bytesRead = anInteger.
	
	^ buffer