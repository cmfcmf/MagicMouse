accessing
sendCommand: aCharacter withBuffer: aBuffer for: aMMBrowserMorph

	| tabId |
	tabId := self getTabIdOf: aMMBrowserMorph.
	self sendCommand: aCharacter withBuffer: aBuffer withId: tabId