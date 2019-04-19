as yet unclassified
open
	| instance |
	instance := self new.
	instance connect.
	instance openInWindowLabeled: 'Magic Mouse Browser'.
	^ instance