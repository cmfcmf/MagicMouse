as yet unclassified
startNodeScript: aString
	| node |
	node := OSProcess isWindows ifTrue: ['node'] ifFalse: ['/usr/bin/node'].
	self startCommand: node withArguments: {aString}