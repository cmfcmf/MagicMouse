<- from chrome
handlePortalMorph: payload

	| info data id next rect morph |
	self assert: [$m = (payload unsignedCharAt: 2)].
	info := self getIdAndRectFrom: payload startAt: 3.
	id := info first.
	rect := info second.
	next := info third.
	
	data := (payload copyFrom: next to: payload size) asString utf8ToSqueak.
	morph := Compiler evaluate: data allButFirst.
	morph
		position: self position + rect origin;
		extent: rect extent;
		yourself.
	self addMorph: morph.
	self portalMorphs at: id put: morph