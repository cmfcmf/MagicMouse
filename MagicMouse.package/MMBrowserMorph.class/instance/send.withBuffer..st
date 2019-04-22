event sending
send: aCommand withBuffer: aBuffer

	process
		stdinPutUint32: (aBuffer size + 1);
		stdinPutChar: aCommand;
		stdinPutBuffer: aBuffer asByteArray