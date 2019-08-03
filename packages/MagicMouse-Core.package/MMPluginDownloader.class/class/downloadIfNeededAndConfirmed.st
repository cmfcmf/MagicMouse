downloading
downloadIfNeededAndConfirmed

	(FileDirectory default fileExists: self filenameForCurrentPlatform) ifFalse: [ 
		self downloadIfConfirmed]