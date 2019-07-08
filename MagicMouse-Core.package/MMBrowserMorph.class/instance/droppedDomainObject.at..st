as yet unclassified
droppedDomainObject: aDomainObject at: aPoint

	| bytes |
	tmpDomainObject := aDomainObject.
	bytes := ByteArray new: 8.
	bytes
		signedLongAt: 1 put: aPoint x;
		signedLongAt: 5 put: aPoint y.
	self sendCommand: $f withBuffer: bytes.