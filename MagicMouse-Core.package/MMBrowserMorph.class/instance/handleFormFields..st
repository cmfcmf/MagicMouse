as yet unclassified
handleFormFields: payload
	| start fields descriptions ids |
	start := 6.
	fields := OrderedCollection new.
	descriptions := OrderedCollection new.
	ids := OrderedCollection new.
	(payload signedLongAt: 2) timesRepeat: [ | h w x y descriptionSize description id idSize |
		x := payload signedLongAt: start.
		y := payload signedLongAt: start + 4.
		w := payload signedLongAt: start + 8.
		h := payload signedLongAt: start + 12.
		descriptionSize := payload unsignedLongAt: start + 16.
		description := payload copyFrom: start + 20 to: start + 20 + descriptionSize - 1.
		start := start + 20 + descriptionSize.
		idSize := payload unsignedLongAt: start.
		id := payload copyFrom: start + 4 to: start + 4 + idSize - 1.
		
		fields add: (x@y extent: w@h).
		descriptions add: description asString.
		ids add: id asString.
		start := start + 4 + idSize].
	
	self submorphs select: [:each | each isKindOf: HObjectFieldMorph] 
		thenDo: [:each | self removeMorph: each].
	fields withIndexDo: [:boundingBox :index | | description id fieldMorph |
		description := descriptions at: index.
		id := ids at: index.
		fieldMorph := (HObjectFieldMorph for: tmpDomainObject wanting: (self domainObjectFieldFor: description object: tmpDomainObject))
			position: self position + boundingBox topLeft;
			extent: boundingBox extent;
			when: #textChanged evaluate: [:text | self contentOfField: id changedTo: text];
			yourself.
		self addMorph: fieldMorph.
		self contentOfField: id changedTo: fieldMorph getTextFromInnerMorphs].
	
	tmpDomainObject := nil