as yet unclassified
peek: aHandle

	^ CMFWinFFI peek: (aHandle getHandle unsignedLongLongAt: 1)