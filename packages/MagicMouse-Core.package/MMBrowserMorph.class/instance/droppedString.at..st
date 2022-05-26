dropping/grabbing
droppedString: aString at: aPoint

	| bytes strBuffer |
	strBuffer := aString withUnixLineEndings squeakToUtf8 asByteArray.
	bytes := ByteArray new: 8.
	bytes
		signedLongAt: 1 put: aPoint x;
		signedLongAt: 5 put: aPoint y.
	MMProcessWrapper getOSDependentSingleton
		sendCommand: $s
		withBuffer: bytes, strBuffer
		for: self
