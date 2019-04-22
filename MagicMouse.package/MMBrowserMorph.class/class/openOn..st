as yet unclassified
openOn: aUrl
	| instance |
	instance := self new.
	instance connect: aUrl.
	instance openInWindowLabeled: 'Magic Mouse Browser'.
	^ instance