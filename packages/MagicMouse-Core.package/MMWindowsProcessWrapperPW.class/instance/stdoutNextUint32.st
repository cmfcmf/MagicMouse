as yet unclassified
stdoutNextUint32
	| n |
	n := self process stdoutStream next.
	n := (n bitShift: 8) + self process stdoutStream next.
	n := (n bitShift: 8) + self process stdoutStream next.
	n := (n bitShift: 8) + self process stdoutStream next.
	^ n