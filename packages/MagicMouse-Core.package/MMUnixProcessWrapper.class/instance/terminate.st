stopping
terminate

	self debugLoggingProcess ifNotNil: [:process | process terminate].
	Transcript showln: 'Killed debug logging process'.
	self process
		closeStreams;
		sigterm