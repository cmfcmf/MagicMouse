event sending
send: anEventType withNumber: firstNumber andNumber: secondNumber

	self send: anEventType withBuffer: ((ByteArray new: 8)
		unsignedLongAt: 1 put: firstNumber asInteger;
		unsignedLongAt: 5 put: secondNumber asInteger;
		yourself)