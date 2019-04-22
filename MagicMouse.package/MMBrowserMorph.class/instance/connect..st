as yet unclassified
connect: aUrl
	| path |
	self assertNodeScriptExists.
	path := self class gitRepositoryPath, FileDirectory slash, 'run.js'.
	
	process := MMProcessWrapper newForOS.
	process enableDebug.
	self flag: #fixme. "Properly escape arguments"
	process startNodeScript: path arguments: {'"', aUrl, '"'}.

	imageUpdaterProcess := [
		 [ | length command payload |
			length := process stdoutNextUint32.
			payload := process stdoutNextBuffer: length.
			command := payload unsignedCharAt: 1.
			command = $i ifTrue: [
				(lastUpdate isNil or: [(TimeStamp now - lastUpdate) asMilliSeconds > 200]) ifTrue: [
					self updateImage: payload. 
					lastUpdate := TimeStamp now
			]]  ifFalse: [self error: 'stream overflow'].
		] repeat
	] fork