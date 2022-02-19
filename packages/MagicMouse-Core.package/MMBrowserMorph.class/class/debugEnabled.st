preferences
debugEnabled
	<preference: 'Debug to Transcript' category: 'MagicMouse' description: 'Print debug output to the Transcript' type: #Boolean>

	^ DebugEnabled ifNil: [false]