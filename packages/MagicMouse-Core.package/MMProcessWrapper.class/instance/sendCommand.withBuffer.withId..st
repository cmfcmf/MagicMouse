accessing
sendCommand: aCharacter withBuffer: aBuffer withId: aNumber

	self
		stdinPutUint32: aBuffer size + 1;
		stdinPutUint32: aNumber;
		stdinPutChar: aCharacter;
		stdinPutBuffer: aBuffer asByteArray