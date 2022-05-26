dropping/grabbing
droppedDomainObject: aDomainObject at: aPoint

	| bytes |
	tmpDomainObject := aDomainObject.
	bytes := ByteArray new: 8.
	bytes
		signedLongAt: 1 put: aPoint x;
		signedLongAt: 5 put: aPoint y.
	MMProcessWrapper getOSDependentSingleton
		sendCommand: $f
		withBuffer: bytes
		for: self