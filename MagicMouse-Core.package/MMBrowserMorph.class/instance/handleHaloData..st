as yet unclassified
handleHaloData: payload
	| type x y w h data form morph |
	type := payload unsignedCharAt: 2.
	x := payload signedLongAt: 3.
	y := payload signedLongAt: 7.
	"w and h do NOT represent the width and height of the received data. Instead, they represent widht and height of the image as displayed on the page, i.e., a if the image is big but scaled down using CSS, width and height represent the scaled down size."
	w := payload signedLongAt: 11.
	h := payload signedLongAt: 15.
	self flag: #fixme. "String encodings :)"
	data := payload copyFrom: 19 to: payload size.
	
	form := Form fromBinaryStream: data readStream.
	form := form scaledToSize: w@h.
	
	morph := ImageMorph new.
	morph 
		position: self position + (x@y);
		image: form.
	self addMorph: morph.
	morph addHalo