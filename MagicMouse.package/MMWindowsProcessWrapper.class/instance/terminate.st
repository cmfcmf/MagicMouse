as yet unclassified
terminate
	self flag: #fixme. "ProcessWrapper>>terminate never returns, therefore we just ask the process to end :("
	[self stdinPutUint32: 0; stdinPutChar: $k] ifError: [] "Silently ignore errors"