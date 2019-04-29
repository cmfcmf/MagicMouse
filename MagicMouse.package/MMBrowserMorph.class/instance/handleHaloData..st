as yet unclassified
handleHaloData: payload
	| type x y w h data morph |
	type := payload unsignedCharAt: 2.
	x := payload signedLongAt: 3.
	y := payload signedLongAt: 7.
	w := payload signedLongAt: 11.
	h := payload signedLongAt: 15.
	self flag: #fixme. "String encodings :)"
	data := payload copyFrom: 19 to: payload size.
	
	morph := ImageMorph new.
	morph 
		position: self position + (x@y);
		image: (Form fromBinaryStream: data readStream).
	self addMorph: morph.
	morph addHalo