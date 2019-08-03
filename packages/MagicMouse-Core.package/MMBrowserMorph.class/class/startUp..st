system startup
startUp: resuming

	resuming ifTrue: [
		DockingBarMorph allInstancesDo: [:each |
		each searchBarMorph instVarNamed: 'setTextSelector' put: #magicSearch:in:].
		self allInstancesDo: [:each | each connect: each location]]