initialization
initialize

	viewportSize := 300 @ 300.
	super initialize.
	self clipSubmorphs: true.
	self color: Color white.
	"Mark the image as opaque. Although we render PNGs, the browser should never send us an image of the webpage that includes transparency."
	self isOpaque: true.
	self image: self class logo.
	self portalMorphs: Dictionary new