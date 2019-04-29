as yet unclassified
eventTypeCode: aType

	^ (Dictionary newFrom: {
		#mouseUp -> 0.
		#mouseDown -> 1.
		#mouseMove -> 2.
		#keyPress -> 3.
		#resize -> 4.
		#mouseWheel -> 5.
		#halo -> 6.
	}) at:  aType ifAbsent: [self error: 'unknown event type']