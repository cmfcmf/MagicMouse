as yet unclassified
shutDown: quitting

	quitting ifTrue: [self allInstancesDo: #dispose]