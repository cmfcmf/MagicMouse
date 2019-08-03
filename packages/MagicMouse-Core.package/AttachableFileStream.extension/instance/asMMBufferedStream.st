*MagicMouse-Core
asMMBufferedStream
	"Answer a replacement for this object, with asynchronous event handling
	and buffered output. Do not close the ioHandle when this object is finalized."

	self keepOpen.
	^ MMBufferedStream
		name: self name
		attachTo: self ioHandle
		writable: self isReadOnly not
