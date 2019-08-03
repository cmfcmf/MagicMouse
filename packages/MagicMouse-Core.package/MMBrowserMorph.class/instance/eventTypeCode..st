-> to chrome
eventTypeCode: aType

	^ (Dictionary newFrom: {
		#mouseLeftUp -> 0.
		#mouseLeftDown -> 1.
		#mouseRightUp -> 2.
		#mouseRightDown -> 3.
		#mouseMove -> 4.
		#keyPress -> 5.
		#resize -> 6.
		#mouseWheel -> 7.
		#portal -> 8.
		#back -> 9.
		#forward -> 10.
	}) at:  aType ifAbsent: [self error: 'unknown event type']