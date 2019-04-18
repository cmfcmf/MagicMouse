as yet unclassified
waitForDataReady
	"Block until at least one character is available in the readBuffer. This is not
	thread safe, and only one Process is permitted to send this message."

	self flag: #fixme. " for some reason the browser stops working after some time when simply using 'self dataAvailableSemaphore wait'"
	(self dataAvailableSemaphore waitTimeoutMSecs: 3000)