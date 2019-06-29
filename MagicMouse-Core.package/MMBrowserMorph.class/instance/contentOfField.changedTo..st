as yet unclassified
contentOfField: id changedTo: text

	| bytes content | 
	content := text asString.
	bytes := ByteArray new: 8 + id byteSize + content byteSize.
	bytes signedLongAt: 1 put: id byteSize.
	bytes replaceFrom: 5 to: 5 + id byteSize - 1 with: id asByteArray.
	
	bytes signedLongAt: 5 + id byteSize put: content byteSize.
	bytes replaceFrom: 5 + id byteSize + 4 to: 5 + id byteSize + 4 + content byteSize - 1 with: content asByteArray.
	self sendCommand: $t withBuffer: bytes