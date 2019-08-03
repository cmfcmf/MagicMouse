stdout
stdoutNextBuffer: anInteger

	self waitFor: anInteger at: stdoutRead.
	^ self readBuffer: stdoutRead length: anInteger