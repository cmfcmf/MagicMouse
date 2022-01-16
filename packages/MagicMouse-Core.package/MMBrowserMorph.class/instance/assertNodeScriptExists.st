connecting
assertNodeScriptExists

	| path directory |
	path := self class gitRepositoryPath.
	directory := FileDirectory on: path.
	self
		assert: [directory exists]
		description: 'You need to specify a valid directory in the Preference Browser'.
	self
		assert: [directory fileExists: 'run.js']
		description: 'The specified directory exists but is missing the run.js file. Make sure to NOT specify the path to the directory cloned via the Git Browser, but rather a manually cloned directory!'.
	self
		assert: [directory directoryExists: 'node_modules']
		description: 'You need to run yarn install inside the MagicMouse git directory.'