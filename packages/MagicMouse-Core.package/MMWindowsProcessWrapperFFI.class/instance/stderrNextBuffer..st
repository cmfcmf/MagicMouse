as yet unclassified
stderrNextBuffer: anInteger

	self waitFor: anInteger at: stderrRead.
	^ self readBuffer: stderrRead length: anInteger