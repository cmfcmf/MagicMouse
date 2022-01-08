stdin
closeTab: aNumber

	self flag: #TODO.
	self browserMorphMapping removeKey: aNumber ifAbsent: [Transcript showln: 'Abandoned BrowserMorph that was not connected to a tab'].
	"TODO, also close tab in nodejs script"