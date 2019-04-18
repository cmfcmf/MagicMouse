as yet unclassified
binary
	"We need to overwrite this method, because it doesn't work when using BufferedAsyncFileReadStreams. If we don't change the readBuffer, the call to 'self uint32' fails, because the underlying collection returns characters."
	self readBuffer: (ReadWriteStream with: ByteArray new).