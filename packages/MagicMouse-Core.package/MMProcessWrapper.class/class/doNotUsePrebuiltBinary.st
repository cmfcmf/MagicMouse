instance creation
doNotUsePrebuiltBinary
	<preference: 'Do not use prebuilt binary' category: 'MagicMouse' description: 'ONLY FOR DEVELOPMENT. If checked, will call the run.js script directly instead of using the prebuilt binaries.' type: #Boolean>

	^ DoNotUsePrebuiltBinary ifNil: [false]