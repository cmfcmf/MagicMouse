as yet unclassified
stdinPutBuffer: aBuffer

	| bytesWritten |
	bytesWritten := CMFWinFFI makePointerOf: ExternalType ulong.
	CMFWinFFI noError: [CMFWinFFI writeFile: (stdinWrite getHandle unsignedLongLongAt: 1)
		buffer: aBuffer asByteArray bytesToWrite: aBuffer size bytesWritten: bytesWritten 
		overlapped: nil].
	bytesWritten := bytesWritten getHandle unsignedLongAt: 1.
	self assert: [bytesWritten = aBuffer size]