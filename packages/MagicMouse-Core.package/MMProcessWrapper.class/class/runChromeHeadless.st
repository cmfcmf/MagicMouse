instance creation
runChromeHeadless
	<preference: 'Run Chrome headless' category: 'MagicMouse' description: 'Running Chrome in headless mode is nicer, because it doesn''t open a window for it. However, extensions don''t work in Chrome headless.' type: #Boolean>

	^ RunChromeHeadless ifNil: [true]