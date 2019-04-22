as yet unclassified
connect
	| path |
	self assertNodeScriptExists.
	path := self class gitRepositoryPath, '/run.js'.
	
	process := MMProcessWrapper newForOS.
	"process enableDebug."
	process startNodeScript: path.

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