event sending
send: anEventType withBuffer: aBuffer

	process
		stdinPutUint32: (aBuffer size + 2);
		stdinPutChar: $e;
		stdinPutUint8: (self class eventTypeCode: anEventType);
		stdinPutBuffer: aBuffer asByteArray