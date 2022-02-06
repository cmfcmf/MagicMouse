stdin
startProcessWithLocation: aUrl withExtend: aPoint for: aMMBrowserMorph

	| binaryToExecutePath runJSPath arguments |
	self class doNotUsePrebuiltBinary
		ifTrue: [
			runJSPath := self class gitRepositoryPath, FileDirectory slash, 'run.js'.
			binaryToExecutePath := OSProcess isWindows
				ifTrue: ['node']
				ifFalse: ['/usr/local/bin/node']]
		ifFalse: [binaryToExecutePath := (FileDirectory default / MMPluginDownloader filenameForCurrentPlatform) fullName].
	arguments := self class debugNodejs
		ifTrue: [{'--inspect'. runJSPath. '--'}]
		ifFalse: [{}].
	arguments := arguments, {
		aUrl.
		aPoint x.
		aPoint y.
		self class runChromeHeadless ifTrue: ['headless'] ifFalse: ['windowed'].
		self class chromeProfilePath}.
	self startCommand: binaryToExecutePath withArguments: arguments.
	self browserMorphMapping at: 0 put: aMMBrowserMorph.
	
	self reactToNodeOutputProcess: [
		[ | length tabId command payload browserInstance |
			length := self stdoutNextUint32.
			tabId := self stdoutNextUint32.
			payload := self stdoutNextBuffer: length.
			command := payload unsignedCharAt: 1.
			
			browserInstance := self browserMorphMapping at: tabId ifAbsent: [
				Transcript showln: 'Received data for unregeistered browser morph. Id is ', tabId.
				self error: Error new].
			command caseOf: {
				[$i] -> [browserInstance updateImage: payload].
				[$h] -> [browserInstance handlePortal: payload].
				[$l] -> [browserInstance locationUpdated: payload].
				[$s] -> [browserInstance handleStructuredData: payload].
				[$g] -> [browserInstance handleGitClone: payload].
				[$f] -> [browserInstance handleFormFields: payload].
				[$.] -> ["This is a filling event to force a flush of the std out of the nodejs script. We ignore this."
				]}] repeat] fork.
	
	self isRunning: true.
	^ 0