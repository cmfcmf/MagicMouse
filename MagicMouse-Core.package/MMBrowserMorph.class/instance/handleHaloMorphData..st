as yet unclassified
handleHaloMorphData: payload

	| info data id next rect morph |
	self assert: [$m = (payload unsignedCharAt: 2)].
	info := self getIdAndRectFrom: payload startAt: 3.
	id := info first. rect := info second. next := info third.
	
	self flag: #fixme. "String encodings :)"
	data := (payload copyFrom: next to: payload size) asString.
	morph := Compiler evaluate: data allButFirst.
	morph
		position: self position + rect origin;
		extent: rect extent;
		yourself.
	self addMorph: morph.
	self portalMorphs at: id put: morph