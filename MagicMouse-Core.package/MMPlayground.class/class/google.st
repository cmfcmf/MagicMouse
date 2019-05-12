as yet unclassified
google
	| stdout process outPipe command reader m |
	Transcript clear.
	outPipe := OSPipe nonBlockingPipe.
	stdout := outPipe writer.
	process := UnixProcess forkJob: '/usr/bin/node' arguments: {'run.js'} environment: nil descriptors: {nil. stdout. nil}.

	reader := outPipe reader asMMBufferedStream.
	reader setBlocking;
		binary.

	m := ImageMorph new.
	m openInHand.

	80 timesRepeat: [
		command := reader next.
		command asCharacter = $i ifTrue: [ | len png |
			len := reader uint32.
			Transcript show: len.
			Transcript cr.
			png := reader next: len.
			m image: (Form fromBinaryStream: png asByteArray readStream).
		] ifFalse: [
		"This usually happens when the readBuffer of the stream overflows."
		Transcript show: 'ERROR'.
	]]
