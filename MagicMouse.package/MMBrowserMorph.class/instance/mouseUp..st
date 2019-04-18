as yet unclassified
mouseUp: anEvent

	| pos |
	pos := anEvent position - self position.
	self
		send: #move withDouble: pos x andDouble: pos y;
		send: #up