-> to chrome
sendEvent: anEventType withBuffer: aBuffer

	MMProcessWrapper getOSDependentSingleton
		sendEvent: (self eventTypeCode: anEventType)
		withBuffer: aBuffer
		for: self
