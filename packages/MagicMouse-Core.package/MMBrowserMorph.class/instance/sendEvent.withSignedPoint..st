-> to chrome
sendEvent: anEventType withSignedPoint: aPoint

	self sendEvent: anEventType withBuffer: ((ByteArray new: 8)
		signedLongAt: 1 put: aPoint x asInteger;
		signedLongAt: 5 put: aPoint y asInteger;
		yourself)