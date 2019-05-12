event sending
sendCommand: aCharacter withBuffer: aBuffer

	process
		stdinPutUint32: (aBuffer size + 1);
		stdinPutChar: aCharacter;
		stdinPutBuffer: aBuffer asByteArray