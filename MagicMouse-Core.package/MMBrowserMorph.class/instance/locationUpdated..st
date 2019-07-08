as yet unclassified
locationUpdated: payload

	location := (payload copyFrom: 2 to: payload size) asString utf8ToSqueak.
	self refreshPortals: {}.
	self triggerEvent: #locationChanged with: location