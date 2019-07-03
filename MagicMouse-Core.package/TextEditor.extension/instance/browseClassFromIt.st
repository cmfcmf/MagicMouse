*MagicMouse-Core
browseClassFromIt
	"Launch a hierarchy browser for the class indicated by the current selection.  If multiple classes matching the selection exist, let the user choose among them."
	| aClass text |
	text := self selection string withBlanksTrimmed.
	self lineSelectAndEmptyCheck: [ ^ self ].
	aClass := UIManager default
		classFromPattern: text
		withCaption: 'choose a class to browse...'
		in: model environment.
	aClass ifNil: [ 
		((text beginsWith: 'http://') or: [text beginsWith: 'https://']) ifTrue: [
			^ MMBrowser openOn: text].
		^ morph flash ].
	self systemNavigation
		spawnHierarchyForClass: aClass
		selector: nil