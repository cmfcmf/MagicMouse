as yet unclassified
testHandleStructuredDataEmpty

	| payload result |
	payload := ByteArray new: 5.
	payload unsignedCharAt: 1 put: $s.
	payload unsignedLongAt: 2 put: 0.
	result := MMBrowserMorph new handleStructuredData: payload.
	self assert: result size equals: 0