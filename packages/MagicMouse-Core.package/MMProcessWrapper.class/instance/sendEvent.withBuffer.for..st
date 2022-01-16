accessing
sendEvent: eventTypeCode withBuffer: aBuffer for: aMMBrowserMorph

	| tabId |
	tabId := self getTabIdOf: aMMBrowserMorph.
	
	self
		stdinPutUint32: aBuffer size + 2;
		stdinPutUint32: tabId;
		stdinPutChar: $e;
		stdinPutUint8: eventTypeCode;
		stdinPutBuffer: aBuffer asByteArray