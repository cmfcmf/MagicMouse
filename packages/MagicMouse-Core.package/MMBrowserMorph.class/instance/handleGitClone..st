<- from chrome
handleGitClone: payload

	| url name nameLength |
	nameLength := payload unsignedLongAt: 2.
	name := (payload copyFrom: 6 to: 6 + nameLength - 1) asString utf8ToSqueak.
	url := (payload copyFrom: 6 + nameLength to: payload size) asString utf8ToSqueak.
	
	self gitClone: url named: name.