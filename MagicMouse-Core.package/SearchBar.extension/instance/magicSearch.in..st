*MagicMouse-Core
magicSearch: text in: morph
	
	(text beginsWith: '!s') 
		ifTrue: [^ MMBrowser searchFor: 'site:squeak.org ', (text copyAfter: $ )].
	((text includes: $ ) or: [text beginsWith: '!']) ifTrue: [^ MMBrowser searchFor: text].

	^ self smartSearch: text in: morph