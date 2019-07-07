initialization
intoWorld: aWorld

	super intoWorld: aWorld.
	self isConnected ifFalse: [self connect: self location]