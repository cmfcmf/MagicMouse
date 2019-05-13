as yet unclassified
handleHaloCodeData: payload
	| info data morph id next rect |
	self assert: [$c = (payload unsignedCharAt: 2)].
	info := self getIdAndRectFrom: payload startAt: 3.
	id := info first. rect := info second. next := info third.
	
	self flag: #fixme. "String encodings :)"
	data := (payload copyFrom: next to: payload size) asString.
	
	morph := MMTextMorphWithModel new.
	morph
		position: self position + rect origin;
		extent: rect extent;
		useDefaultStyler;
		setText: data;
		yourself.
	self addMorph: morph.
	self portalMorphs at: id put: morph.
	World activeHand newKeyboardFocus: morph