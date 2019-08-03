as yet unclassified
getBrowserMorph
	browser isConnected ifFalse: [
		browser connect: self locationText. 
		browser layoutFrame: (LayoutFrame fractions: (0@0 extent: 1@1)).
		browser when: #locationChanged send: #locationText: to: self.
		browser when: #structuredDataChanged send: #structuredDataChanged: to: self].
	^ { browser }