event sending
send: anEventType withNumber: aNumber

	self send: anEventType withBuffer: ((ByteArray new: 4)
		unsignedLongAt: 1 put: aNumber asInteger;
		yourself)