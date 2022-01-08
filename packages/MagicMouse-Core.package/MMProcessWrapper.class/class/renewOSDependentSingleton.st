instance creation
renewOSDependentSingleton

	 OSDependentProcessSingleton := OSProcess isWindows
		ifTrue: ["Smalltalk platformSubtype = 'X64' 
			ifTrue: ["MMWindowsProcessWrapperFFI new"] 
			ifFalse: [MMWindowsProcessWrapperPW new]"] 
		ifFalse: [MMUnixProcessWrapper new].
		
	^ OSDependentProcessSingleton