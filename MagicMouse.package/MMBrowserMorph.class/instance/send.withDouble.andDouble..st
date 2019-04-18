event sending
send: anEventType withDouble: firstNumber andDouble: secondNumber

	self flag: #fixme. " may need to send integers instead if the float format is non-standard/nodejs incompatible "
	self send: anEventType withBuffer: ((ByteArray new: 8)
		unsignedLongAt: 1 put: firstNumber asInteger;
		unsignedLongAt: 5 put: secondNumber asInteger;
		yourself)