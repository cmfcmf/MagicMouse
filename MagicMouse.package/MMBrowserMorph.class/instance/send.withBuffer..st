event sending
send: anEventType withBuffer: aBuffer

	processWriter
		nextPut: $e asciiValue;
		nextPut: (self class eventTypeCode: anEventType);
		uint32: aBuffer size;
		nextPutAll: aBuffer