event sending
send: anEventType withBuffer: aBuffer

	processWriter
		nextPut: $e asciiValue;
		uint32: aBuffer size;
		nextPut: (self class eventTypeCode: anEventType);
		nextPutAll: aBuffer;
		flush