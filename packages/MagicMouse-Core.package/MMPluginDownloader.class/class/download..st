downloading
download: aString

	UIManager default informUserDuring: [:bar |
		| document fileStream |
		bar value: 'Downloading plugin'.
		document := ('https://dl.bintray.com/cmfcmf/MagicMouse/', aString) asUrl retrieveContents.
		bar value: 'Saving plugin'.
		fileStream := FileDirectory default fileNamed: aString.
		fileStream
			binary;
			nextPutAll: document content;
			close.
		OSProcess isUnix ifTrue: [OSProcess command: 'chmod +x ', fileStream fullName]]