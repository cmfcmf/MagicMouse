*MagicMouse-Core
findFirst: aBlock startingAt: anInteger
	"Return the index of my first element for which aBlock evaluates as true."

	| index |
	index := anInteger - 1.
	[(index := index + 1) <= self size] whileTrue:
		[(aBlock value: (self at: index)) ifTrue: [^index]].
	^ 0