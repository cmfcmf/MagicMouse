private
waitFor: anInteger at: aHandle

	[(self peek: aHandle) < anInteger] whileTrue: [
		(Delay forMilliseconds: 5) wait
		"Processor yield"]