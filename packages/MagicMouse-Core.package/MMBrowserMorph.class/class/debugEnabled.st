as yet unclassified
debugEnabled

	<preference: 'Enable debug'
		category: 'MagicMouse'
		description: 'Print debug output to the Transcript'
		type: #Boolean>
	^ DebugEnabled ifNil: [false]