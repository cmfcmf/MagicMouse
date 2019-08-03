as yet unclassified
downloadIfConfirmed

	| confirmation |
	confirmation := self confirm: 'To use MagicMouse, you need to download/update an additional binary to interface with Chrome/Chromium. Do you want to continue and download now?'.
	confirmation ifTrue: [self download]