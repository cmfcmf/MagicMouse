as yet unclassified
newForOS
	^ OSProcess isWindows
		ifTrue: [MMWindowsProcessWrapper new] 
		ifFalse: [MMUnixProcessWrapper new].