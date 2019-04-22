as yet unclassified
gitRepositoryPath

	<preference: 'The path to the git repository that contains the run.js file and node_modules folder '
		category: 'MagicMouse'
		description: 'You may NOT use the repository checked out by the Git Browser, but need to use a separate copy.'
		type: #String>
	^ GitRepositoryPath ifNil: ['.']