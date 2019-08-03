-> to chrome
sendCommand: aCharacter withBuffer: aBuffer

	self process
		stdinPutUint32: (aBuffer size + 1);
		stdinPutChar: aCharacter;
		stdinPutBuffer: aBuffer asByteArray