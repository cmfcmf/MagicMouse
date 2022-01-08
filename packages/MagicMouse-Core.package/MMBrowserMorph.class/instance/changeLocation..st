public
changeLocation: aUrl

	location := aUrl.
	MMProcessWrapper getOSDependentSingleton sendCommand: $l withBuffer:  aUrl asByteArray for: self