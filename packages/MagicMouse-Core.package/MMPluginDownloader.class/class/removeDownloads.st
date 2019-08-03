as yet unclassified
removeDownloads

	self filenameDict valuesDo: [:each | 	FileDirectory default deleteFileNamed: each ifAbsent: []]