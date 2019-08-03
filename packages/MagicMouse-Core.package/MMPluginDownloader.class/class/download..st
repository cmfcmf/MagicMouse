as yet unclassified
download: aString

	UIManager default informUserDuring: [:bar |
		| document |
		bar value: 'Downloading plugin'.
		document := ('https://dl.bintray.com/cmfcmf/MagicMouse/', aString) asUrl retrieveContents.
		bar value: 'Saving plugin'.
		(FileDirectory default fileNamed: aString)
			binary;
			nextPutAll: document content;
			close]