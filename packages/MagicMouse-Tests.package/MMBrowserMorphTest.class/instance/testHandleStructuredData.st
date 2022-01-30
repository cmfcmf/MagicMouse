as yet unclassified
testHandleStructuredData

	| payload result |
	payload := ByteArray new: 11.
	payload unsignedCharAt: 1 put: $s.
	payload unsignedLongAt: 2 put: 1.
	payload unsignedLongAt: 6 put: 2.
	payload unsignedCharAt: 10 put: ${.
	payload unsignedCharAt: 11 put: $}.
	result := MMBrowserMorph new handleStructuredData: payload.
	self assert: result size equals: 1.
	self assert: result first size equals: 0