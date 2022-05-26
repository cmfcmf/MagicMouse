accessing
throwTimeoutError

	throwTimeoutError ifNil: [throwTimeoutError := false].
	^ throwTimeoutError