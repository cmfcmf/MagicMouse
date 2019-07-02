*MagicMouse-Core
magicSearch: text in: morph
	
	(text beginsWith: '!s') 
		ifTrue: [^ MMBrowser searchFor: 'site:squeak.org ', (text copyAfter: $ )].
	(text includes: $ ) ifTrue: [^ MMBrowser searchFor: text].
	(text beginsWith: '!') ifTrue: [^ MMBrowser searchFor: (text copyAfter: $!)].
	^ self smartSearch: text in: morph