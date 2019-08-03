starting
startCommand: command withArguments: arguments

	|  startupInfo pipe commandLine |
	self flag: #todo. "Properly escape arguments?"
	commandLine := command, ' ', ((arguments collect: [:arg | '"', arg, '"']) joinSeparatedBy: ' ').
	
	pipe := CMFWinFFI makePipe: false.
	stdinRead := pipe first.
	stdinWrite := pipe second.
	
	pipe := CMFWinFFI makePipe: true size: 1000000000.
	stdoutRead := pipe first.
	stdoutWrite := pipe second.
	
	debug ifTrue: [
		pipe := CMFWinFFI makePipe: true.
		stderrRead := pipe first.
		stderrWrite := pipe second].
	
	startupInfo := CMFWinStartupInfo new.
	startupInfo 
		cb: CMFWinStartupInfo byteSize;
		dwFlags: (
			16r1 "STARTF_USESHOWWINDOW"
			bitOr: 16r100 "STARTF_USESTDHANDLES");
		wShowWindow: 0; "SW_HIDE"
		hStdInput: (stdinRead getHandle unsignedLongLongAt: 1);
		hStdOutput: (stdoutWrite getHandle unsignedLongLongAt: 1);
		yourself.
	debug ifTrue: [startupInfo hStdError: (stderrWrite getHandle unsignedLongLongAt: 1)].
	
	processInformation := CMFWinProcessInformation new.
	CMFWinFFI noError: [CMFWinFFI createProcessApplicationName: nil 
		commandLine: commandLine
		processAttributes: nil 
		threadAttributes: nil 
		inheritHandles: true 
		creationFlags: 0 
		environment: nil 
		currentDirectory: nil 
		startupInfo: startupInfo 
		processInformation: processInformation].
	
	debug ifTrue: [
		Transcript clear.
		[[[ | bytesAvailable |
			bytesAvailable := self peek: stderrRead. 
			bytesAvailable > 0
				ifTrue: [Transcript show: (self stderrNextBuffer: bytesAvailable) asString].
			(Delay forMilliseconds: 200) wait.
			true] ifError: [false]] whileTrue] fork]