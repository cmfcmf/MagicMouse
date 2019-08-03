as yet unclassified
downloadIfNeededAndConfirmed

	(FileDirectory default fileExists: self filenameForCurrentPlatform) ifFalse: [ 
		self downloadIfConfirmed]