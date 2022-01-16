starting
startNodeScript: aString arguments: arguments nodeArguments: nodeArguments

	| node |
	node := OSProcess isWindows ifTrue: ['node'] ifFalse: ['/usr/local/bin/node'].
	self startCommand: node withArguments: nodeArguments, {aString. '--'}, arguments