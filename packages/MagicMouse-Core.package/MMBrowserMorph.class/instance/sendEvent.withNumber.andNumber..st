event sending
sendEvent: anEventType withNumber: firstNumber andNumber: secondNumber

	self sendEvent: anEventType withBuffer: ((ByteArray new: 8)
		unsignedLongAt: 1 put: firstNumber asInteger;
		unsignedLongAt: 5 put: secondNumber asInteger;
		yourself)