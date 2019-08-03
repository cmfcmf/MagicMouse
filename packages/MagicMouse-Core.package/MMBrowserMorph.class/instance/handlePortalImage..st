<- from chrome
handlePortalImage: payload

	| data form morph id info next rect |
	self assert: [$i = (payload unsignedCharAt: 2)].
	info := self getIdAndRectFrom: payload startAt: 3.
	id := info first. rect := info second. next := info third.
	
	data := payload copyFrom: next to: payload size.
	
	form := Form fromBinaryStream: data readStream.
	form := form scaledToSize: rect extent.
	
	morph := ImageMorph new.
	morph 
		position: self position + rect origin;
		image: form.
	self portalMorphs at: id put: morph.
	self addMorph: morph.
	morph addHalo