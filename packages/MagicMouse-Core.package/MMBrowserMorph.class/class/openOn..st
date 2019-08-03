instance creation
openOn: aUrl

	^ self new
		connect: aUrl;
		openInWindowLabeled: self title;
		yourself