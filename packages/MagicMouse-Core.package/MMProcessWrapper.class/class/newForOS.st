instance creation
newForOS

	^ OSProcess isWindows
		ifTrue: ["Smalltalk platformSubtype = 'X64' 
			ifTrue: ["MMWindowsProcessWrapperFFI new"] 
			ifFalse: [MMWindowsProcessWrapperPW new]"] 
		ifFalse: [MMUnixProcessWrapper new].