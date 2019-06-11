as yet unclassified
handleStructuredData: payload
	| start structuredData |
	start := 6.
	structuredData := OrderedCollection new.
	(payload unsignedLongAt: 2) timesRepeat: [ | json length |
		length := payload unsignedLongAt: start.
		json := payload copyFrom: start + 4 to: start + 4 + length - 1.
		structuredData add: (Json readFrom: json asString readStream).
		start := start + 4 + length].
	self triggerEvent: #structuredDataChanged with: structuredData.
	^ structuredData