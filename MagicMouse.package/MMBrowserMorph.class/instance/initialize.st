initialization
initialize

	viewportSize := 590@338.
	super initialize.
	self clipSubmorphs: true.
	self color: Color white.
	"Mark the image as opaque. Although we render PNGs, the browser should never send us an image of the webpage that includes transparency."
	self isOpaque: true