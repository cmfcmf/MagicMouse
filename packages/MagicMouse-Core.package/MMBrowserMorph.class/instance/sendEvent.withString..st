-> to chrome
sendEvent: anEventType withString: aString

	self sendEvent: anEventType withBuffer: aString squeakToUtf8 asByteArray