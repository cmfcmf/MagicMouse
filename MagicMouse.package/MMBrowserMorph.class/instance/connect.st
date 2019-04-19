as yet unclassified
connect

	| stdout outPipe command reader inPipe stdin |
	outPipe := OSPipe nonBlockingPipe.
	inPipe := OSPipe blockingPipe.
	stdin := inPipe reader.
	stdout := outPipe writer.
	
	processWriter := inPipe writer binary.
	
	process := UnixProcess forkJob: '/usr/bin/node' arguments: {'run.js'} environment: nil descriptors: {stdin. stdout. nil}.
	
	reader := outPipe reader asMMBufferedStream.
	reader
		setBlocking;
		binary.

	imageUpdaterProcess := [
		 [
			command := reader next asCharacter.
			command = $i ifTrue: [ | format |
				format := reader next asCharacter.
				self updateImage: reader format: format
			] ifFalse: [self error: 'stream overflow']
		] repeat
	] fork