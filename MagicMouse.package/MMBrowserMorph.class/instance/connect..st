as yet unclassified
connect: aUrl
	| path |
	self assertNodeScriptExists.
	path := self class gitRepositoryPath, FileDirectory slash, 'run.js'.
	
	process := MMProcessWrapper newForOS.
	"process enableDebug."
	process startNodeScript: path arguments: {aUrl}.

	imageUpdaterProcess := [
		 [ | length command payload |
			length := process stdoutNextUint32.
			payload := process stdoutNextBuffer: length.
			command := payload unsignedCharAt: 1.
			command caseOf: {
				[$i] -> [(lastUpdate isNil or: [(TimeStamp now - lastUpdate) asMilliSeconds > 200]) ifTrue: [
					self updateImage: payload. 
					lastUpdate := TimeStamp now
				]].
				[$h] -> [self handleHaloData: payload]
			}
		] repeat
	] fork