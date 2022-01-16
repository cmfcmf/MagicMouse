-> to chrome
contentOfField: anId changedTo: text

	| bytes content id |
	id := anId squeakToUtf8.
	content := text asString squeakToUtf8.
	bytes := ByteArray new: 8 + id byteSize + content byteSize.
	bytes signedLongAt: 1 put: id byteSize.
	bytes replaceFrom: 5 to: 5 + id byteSize - 1 with: id asByteArray.
	
	bytes signedLongAt: 5 + id byteSize put: content byteSize.
	bytes
		replaceFrom: 5 + id byteSize + 4
		to: 5 + id byteSize + 4 + content byteSize - 1
		with: content asByteArray.
	MMProcessWrapper getOSDependentSingleton
		sendCommand: $t
		withBuffer: bytes
		for: self