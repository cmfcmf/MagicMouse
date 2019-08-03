system startup
shutDown: quitting

	quitting ifTrue: [self allInstancesDo: #dispose]