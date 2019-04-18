as yet unclassified
eventTypeCode: aType

	^ (Dictionary newFrom: {
		#mouseUp -> 0.
		#mouseDown -> 1.
		#mouseMove -> 2.
		#keyboardDown -> 3.
		#keyboardUp -> 4
	}) at:  aType ifAbsent: [self error: 'unknown event type']