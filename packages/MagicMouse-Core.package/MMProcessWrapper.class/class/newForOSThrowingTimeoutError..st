instance creation
newForOSThrowingTimeoutError: aBoolean

	^ OSProcess isWindows
		ifTrue: ["Smalltalk platformSubtype = 'X64' 
			ifTrue: ["MMWindowsProcessWrapperFFI new throwsTimeoutError: aBoolean"] 
			ifFalse: [MMWindowsProcessWrapperPW new]"] 
		ifFalse: [MMUnixProcessWrapper new throwsTimeoutError: aBoolean].