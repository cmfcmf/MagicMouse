event sending
sendEvent: anEventType withNumber: aNumber

	self sendEvent: anEventType withBuffer: ((ByteArray new: 4)
		unsignedLongAt: 1 put: aNumber asInteger;
		yourself)