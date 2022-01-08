accessing
sendCommand: aCharacter withBuffer: aBuffer for: aMMBrowserMorph

	|tabId|	

	tabId := self getTabIdOf: aMMBrowserMorph.

	self 
		stdinPutUint32: (aBuffer size + 1);
		stdinPutUint32: tabId;
		stdinPutChar: aCharacter;
		stdinPutBuffer: aBuffer asByteArray