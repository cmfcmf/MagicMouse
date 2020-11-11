drawing
drawOn: aCanvas

	"Draw my background color to cover the areas when my viewport doesn't match my extent."
	aCanvas fillRectangle: self bounds color: self color.
	super drawOn: aCanvas