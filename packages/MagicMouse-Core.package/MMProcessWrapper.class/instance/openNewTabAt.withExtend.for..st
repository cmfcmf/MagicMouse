stdin
openNewTabAt: aUrl withExtend: aPoint for: aMMbrowserMorph

	|newTabId buffer|
	newTabId := (self browserMorphMapping keys max) + 1.
	buffer := aUrl asByteArray.
	self 
		stdinPutUint32: (buffer size + 1 + (2*4));
		stdinPutUint32: newTabId;
		stdinPutChar: $n;
		stdinPutUint32: aPoint x;
		stdinPutUint32: aPoint y;
		stdinPutBuffer: buffer asByteArray.
	self browserMorphMapping at: newTabId put: aMMbrowserMorph.
	^ newTabId