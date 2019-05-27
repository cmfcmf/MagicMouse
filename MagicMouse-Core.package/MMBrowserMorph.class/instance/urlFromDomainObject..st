as yet unclassified
urlFromDomainObject: aDomainObject

	| url |
	^ #(url website homepage uri domain) 
		detect: [:message |
			url := aDomainObject ? message.
			url notNil and: [url notEmpty]] 
		ifFound: [:message | url]
		ifNone: [nil]