<- from chrome
getIdAndRectFrom: payload startAt: start

	| id x y w h idEnd |
	idEnd := (payload findFirst: [:each | each = 0] startingAt: start).
	id := (payload copyFrom: start to: idEnd - 1) asString utf8ToSqueak.
	x := payload signedLongAt: idEnd + 1.
	y := payload signedLongAt: idEnd + 5.
	w := payload signedLongAt: idEnd + 9.
	h := payload signedLongAt: idEnd + 13.

	^ Array with: id with: (x@y extent: w@h) with: idEnd + 17