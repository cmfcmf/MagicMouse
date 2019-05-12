as yet unclassified
updateImage: payload
	| format png form |
	format := payload unsignedCharAt: 2.
	format = $r ifTrue: [ | width height |
		width := payload unsignedLongAt: 3.
		height := payload unsignedLongAt: 7.
		png := payload copyFrom: 11 to: payload size.
		form := Form extent: width@height depth: 32.
		1 to: (width * height - 1) do: [:index | form bits at: index put: (
			(((png at: index * 4 + 3) asInteger) <<   0) + 
			(((png at: index * 4 + 2) asInteger) <<   8) + 
			(((png at: index * 4 + 1) asInteger) << 16) + 
			(((png at: index * 4 + 0) asInteger) << 24)
		)]. 
	].
	format = $p ifTrue: [
		png := payload copyFrom: 3 to: payload size.
		form := Form fromBinaryStream: png readStream ].

	self flag: #fixme. "Check if the optimization using displayOn:at:rule is faster"
	self flag: #fixme. "Check if the rule constant `Form over` is the best and fastest"
	self image extent = form extent ifTrue: [self changed. 
		form displayOn: self image at: 0@0 rule: Form paint] ifFalse: [self image: form]