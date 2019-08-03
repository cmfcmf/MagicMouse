as yet unclassified
debugNodejs

	<preference: 'Enable Node.js debugging'
		category: 'MagicMouse'
		description: 'Start Node.js with the --inspect argument'
		type: #Boolean>
	^ DebugNodejs ifNil: [false]