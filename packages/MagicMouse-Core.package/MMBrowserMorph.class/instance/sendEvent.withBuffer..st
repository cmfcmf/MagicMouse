-> to chrome
sendEvent: anEventType withBuffer: aBuffer

	self process
		stdinPutUint32: aBuffer size + 2;
		stdinPutChar: $e;
		stdinPutUint8: (self eventTypeCode: anEventType);
		stdinPutBuffer: aBuffer asByteArray