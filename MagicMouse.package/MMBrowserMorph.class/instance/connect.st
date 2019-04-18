as yet unclassified
connect

	| stdout outPipe command reader inPipe stdin |
	Transcript clear.
	outPipe := OSPipe nonBlockingPipe.
	inPipe := OSPipe blockingPipe.
	stdin := inPipe reader.
	stdout := outPipe writer.
	
	processWriter := inPipe writer setBlocking; binary.
	
	process := UnixProcess forkJob: '/usr/bin/node' arguments: {'run.js'} environment: nil descriptors: {stdin. stdout. nil}.
	
	reader := outPipe reader asMMBufferedStream.
	reader
		setBlocking;
		binary.
	
	running := true.
	[
		 [
			command := reader next.
			command asCharacter = $i ifTrue: [self updateImage: reader] ifFalse: [self error: 'stream overflow']
		] doWhileTrue: [running]
	] fork