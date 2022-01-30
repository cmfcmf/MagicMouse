stopping
terminate

	self flag: #todo.
	"ProcessWrapper>>terminate never returns, therefore we just ask the process to end :("
	[
		self
			stdinPutUint32: 1;
			stdinPutChar: $k] ifError: ["Silently ignore errors"
	]