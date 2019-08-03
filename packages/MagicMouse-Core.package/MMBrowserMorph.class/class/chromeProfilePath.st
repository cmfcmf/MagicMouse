as yet unclassified
chromeProfilePath

	<preference: 'Chrome profile path'
		category: 'MagicMouse'
		description: 'The path to the folder to store the Chrome user profile in. You can leave this empty to store it in your Squeak folder.'
		type: #String>
	^ ChromeProfilePath ifNil: [(FileDirectory default / 'chromeUserDir') name]