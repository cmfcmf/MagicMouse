stdin
closeTab: aNumber

	(self browserMorphMapping includesKey: aNumber) ifFalse: [^ nil].
	self sendCommand: $k withBuffer: '' asByteArray withId: aNumber.
	self browserMorphMapping removeKey: aNumber ifAbsent: [].
	Transcript showln: 'Closed Browser with tabId: ', aNumber asString.
	self browserMorphMapping isEmpty ifTrue: [
		Transcript showln: 'All Browser tabs should be closed. Killing Chrome ...'.
		self class mmCleanUp]