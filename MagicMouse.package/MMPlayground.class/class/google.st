as yet unclassified
google
	| stdout process outPipe command reader m |
	Transcript clear.
	outPipe := OSPipe nonBlockingPipe.
	stdout := outPipe writer.
	process := UnixProcess forkJob: '/usr/bin/node' arguments: {'js/run.js'} environment: nil descriptors: {nil. stdout. nil}.

	reader := outPipe reader asBufferedAsyncFileReadStream. "asMMBufferedStream."
	reader setBlocking.
	
	"Does not have effect on BufferedAsyncFileReadStreams. We need to change the readBuffer directly instead.
	When we don't change the readBuffer, the call to 'reader uint32' fails, because the underlying collection returns characters."
	reader binary. 
	reader readBuffer: (ReadWriteStream with: ByteArray new).

	m := ImageMorph new.
	m openInHand.

	80 timesRepeat: [
		command := reader next.
		command asCharacter = $i ifTrue: [ | len png |
			len := reader uint32.
			Transcript show: len.
			Transcript cr.
			png := reader next: len.
			m image: (Form fromBinaryStream: png readStream).
		] ifFalse: [
		"This usually happens when the readBuffer of the BufferedAsyncFileReadStreams overflows."
		Transcript show: 'ERROR'.
	]]
