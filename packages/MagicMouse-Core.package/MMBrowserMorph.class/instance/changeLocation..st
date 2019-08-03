public
changeLocation: aUrl

	location := aUrl.
	self sendCommand: $l withBuffer: aUrl asByteArray