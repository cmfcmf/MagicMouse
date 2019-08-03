stdout
stdoutNextUint8

	| buffer |
	buffer := self stdoutNextBuffer: 1.
	^ buffer byteAt: 1