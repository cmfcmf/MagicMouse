as yet unclassified
startNodeScript: aString arguments: arguments
	| node |
	node := OSProcess isWindows ifTrue: ['node'] ifFalse: ['/usr/bin/node'].
	self startCommand: node withArguments: ({aString . '--'}, arguments)