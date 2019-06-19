as yet unclassified
locationUpdated: payload

	location := (payload copyFrom: 2 to: payload size) asString.
	self triggerEvent: #locationChanged with: location