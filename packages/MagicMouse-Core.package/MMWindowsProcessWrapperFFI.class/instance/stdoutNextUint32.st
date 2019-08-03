as yet unclassified
stdoutNextUint32
	| n buffer |
	buffer := self stdoutNextBuffer: 4.
	n := buffer byteAt: 1.
	n := (n bitShift: 8) + (buffer byteAt: 2).
	n := (n bitShift: 8) + (buffer byteAt: 3).
	n := (n bitShift: 8) + (buffer byteAt: 4).
	^ n