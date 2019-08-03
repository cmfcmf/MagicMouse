as yet unclassified
downloadIfConfirmed

	| confirmed |
	confirmed := true.
	Smalltalk at: #SmalltalkCI ifAbsent: [
		"Don't ask for confirmation when running SmalltalkCI"
		confirmed := self confirm: 'To use MagicMouse, you need to download/update an additional binary to interface with Chrome/Chromium. Do you want to continue and download now?'].
	confirmed ifTrue: [self download]