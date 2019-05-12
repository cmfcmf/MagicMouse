as yet unclassified
waitFor: anInteger at: aHandle

	| bytesAvailable |
	bytesAvailable := 0.
	[bytesAvailable < anInteger] whileTrue: [
		bytesAvailable := self peek: aHandle.
		(Delay forMilliseconds: 10) wait]