as yet unclassified
connect: aUrl
	| path |
	self assertNodeScriptExists.
	path := self class gitRepositoryPath, FileDirectory slash, 'run.js'.
	
	process := MMProcessWrapper newForOS.
	self class debugEnabled ifTrue: [process enableDebug].
	process startNodeScript: path 
		arguments: {aUrl. viewportSize x. viewportSize y.
			self class runChromeHeadless ifTrue: ['headless'] ifFalse: ['windowed'].
			self class chromeProfilePath}
		nodeArguments: (self class debugNodejs ifTrue: [{'--inspect'}] ifFalse: [{}]).
	
	location := aUrl.

	imageUpdaterProcess := [
		 [ | length command payload |
			length := process stdoutNextUint32.
			payload := process stdoutNextBuffer: length.
			command := payload unsignedCharAt: 1.
			command caseOf: {
				[$i] -> [self updateImage: payload].
				[$h] -> [self handleHaloData: payload].
				[$l] -> [self locationUpdated: payload].
				[$s] -> [self handleStructuredData: payload].
				[$g] -> [self handleGitClone: payload].
				[$f] -> [self handleFormFields: payload]
			}
		] repeat
	] fork