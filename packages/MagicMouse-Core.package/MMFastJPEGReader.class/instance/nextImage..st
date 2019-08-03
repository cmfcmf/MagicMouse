as yet unclassified
nextImage: aForm

	| bytes width height components jpegDecompressStruct jpegErrorMgr2Struct form |
	bytes := stream upToEnd.
	stream close.
	jpegDecompressStruct := ByteArray new: self primJPEGDecompressStructSize.
	jpegErrorMgr2Struct := ByteArray new: self primJPEGErrorMgr2StructSize.
	self 
		primJPEGReadHeader: jpegDecompressStruct 
		fromByteArray: bytes
		errorMgr: jpegErrorMgr2Struct.
	width := self primImageWidth: jpegDecompressStruct.
	height := self primImageHeight: jpegDecompressStruct.
	components := self primImageNumComponents: jpegDecompressStruct.
	
	(aForm extent = (width@height) and: [aForm depth = 32])
		ifTrue: [form := aForm]
		ifFalse: [form := Form extent: width@height depth: 32].
	
	self
		primJPEGReadImage: jpegDecompressStruct
		fromByteArray: bytes
		onForm: form
		doDithering: true
		errorMgr: jpegErrorMgr2Struct.
	^ form