preferences
gitRepositoryPath

	<preference: 'Git Repository Path'
		category: 'MagicMouse'
		description: 'ONLY FOR DEVELOPMENT. The path to the git repository that contains the run.js file and node_modules folder. You may NOT use the repository checked out by the Git Browser, but need to use a separate copy.'
		type: #String>
	^ GitRepositoryPath ifNil: ['.']