read ahead buffer
waitForDataReady
	"Block until at least one character is available in the readBuffer. This is not
	thread safe, and only one Process is permitted to send this message."

	self flag: #todo.
	" for some reason the browser stops working after some time when simply using 'self dataAvailableSemaphore wait'"
	[true] whileTrue: [
		(self dataAvailableSemaphore waitTimeoutMSecs: 30000)
			ifTrue: ["todo check whether error should be throw"
			self throwTimeoutError ifTrue: [self error: 'Did not receive a frame in 30 seconds']]
			ifFalse: [^ self]
		"(self dataAvailableSemaphore waitTimeoutMSecs: 30000) ifTrue: [self error: 'Did not receive a frame in 30 seconds']"]