as yet unclassified
handleGitClone: payload
	| url name nameLength |
	self flag: #fixme. "String encodings :)"
	nameLength := payload unsignedLongAt: 2.
	name := (payload copyFrom: 6 to: 6 + nameLength - 1) asString.
	url := (payload copyFrom: 6 + nameLength to: payload size) asString.
	
	self gitClone: url named: name.