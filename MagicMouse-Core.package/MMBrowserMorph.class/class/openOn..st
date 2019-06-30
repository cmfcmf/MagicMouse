as yet unclassified
openOn: aUrl

	^ self new
		connect: aUrl;
		openInWindowLabeled: self title;
		yourself