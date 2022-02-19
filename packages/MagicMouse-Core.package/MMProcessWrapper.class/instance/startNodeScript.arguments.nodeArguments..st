starting
startNodeScript: aString arguments: arguments nodeArguments: nodeArguments

	| node |
	node := OSProcess isWindows ifTrue: ['node'] ifFalse: ['/usr/bin/node'].
	self startCommand: node withArguments: nodeArguments, {aString. '--'}, arguments