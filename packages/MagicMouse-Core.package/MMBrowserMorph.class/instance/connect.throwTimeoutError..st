connecting
connect: aUrl throwTimeoutError: aBoolean

	| path arguments |
	process := MMProcessWrapper newForOSThrowingTimeoutError: aBoolean.
	self class debugEnabled ifTrue: [process enableDebug].
	arguments := {aUrl. viewportSize x. viewportSize y.
		self class runChromeHeadless ifTrue: ['headless'] ifFalse: ['windowed'].
		self class chromeProfilePath}.
	self class doNotUsePrebuiltBinary
		ifTrue: [
			self assertNodeScriptExists.
			path := self class gitRepositoryPath, FileDirectory slash, 'run.js'.
			process
				startNodeScript: path 
				arguments: arguments
				nodeArguments: (self class debugNodejs ifTrue: [{'--inspect'}] ifFalse: [{}])]
		ifFalse: [
			path := (FileDirectory default / MMPluginDownloader filenameForCurrentPlatform) fullName.
			process startCommand: path withArguments: arguments].
	
	location := aUrl.

	imageUpdaterProcess := [
		 [ | length command payload |
			length := process stdoutNextUint32.
			payload := process stdoutNextBuffer: length.
			command := payload unsignedCharAt: 1.
			command caseOf: {
				[$i] -> [self updateImage: payload].
				[$h] -> [self handlePortal: payload].
				[$l] -> [self locationUpdated: payload].
				[$s] -> [self handleStructuredData: payload].
				[$g] -> [self handleGitClone: payload].
				[$f] -> [self handleFormFields: payload]
			}
		] repeat
	] fork