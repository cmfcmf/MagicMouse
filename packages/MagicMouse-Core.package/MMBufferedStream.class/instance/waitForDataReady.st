read ahead buffer
waitForDataReady

	"Block until at least one character is available in the readBuffer. This is not
	thread safe, and only one Process is permitted to send this message."
	
	self flag: #todo. " for some reason the browser stops working after some time when simply using 'self dataAvailableSemaphore wait'"
	[true] whileTrue: [
		(self dataAvailableSemaphore waitTimeoutMSecs: 30000) 
		"todo check whether error should be throw"
			ifTrue: [self throwTimeoutError ifTrue: [ self error: 'Did not receive a frame in 30 seconds']] 
			ifFalse:[Transcript showln: 'GOT SOME DATA YAY!!!!!'. ^ self]
	].
	