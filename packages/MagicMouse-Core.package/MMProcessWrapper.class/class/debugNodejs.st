instance creation
debugNodejs

	<preference: 'Debug Node.js'
		category: 'MagicMouse'
		description: 'ONLY FOR DEVELOPMENT. Start Node.js with the --inspect argument'
		type: #Boolean>
	^ DebugNodejs ifNil: [false]