as yet unclassified
startCommand: command withArguments: arguments
	| stdout outPipe inPipe stdin |
	outPipe := OSPipe nonBlockingPipe.
	stdout := outPipe writer.

	inPipe := OSPipe blockingPipe.
	stdin := inPipe reader.
	stdinWriter := inPipe writer binary.

	process := UnixProcess 
		forkJob: command
		arguments: arguments
		environment: nil 
		descriptors: {stdin. stdout. nil}.

	stdoutReader := outPipe reader asMMBufferedStream.
	stdoutReader
		setBlocking;
		binary.