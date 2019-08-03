<- from chrome
gitClone: url named: name

	"This code is based on SquitBrowser>>actionProjectClone"
	| browser workingCopy directory repositoryPath |
	browser := SquitBrowser new.
	self assert: (browser isRemoteSupported: url).

	workingCopy := SquotWorkingCopy newOnObjectMemory.
	workingCopy name: name.
	directory := (UIManager default chooseDirectory: 'Repository directory').
	directory ifNil: [^ self].
	repositoryPath := directory pathName.
	workingCopy repository: (SquitRepository new initializeInDirectory: (FileSystem disk root resolve: repositoryPath)).
	workingCopy loadedHistorian: (workingCopy repository historianNamed: 'master').
	workingCopy register.

	browser withRemoteErrorHandlingDo: [
		browser handlingCredentialsOf: workingCopy loadedHistorian 
			do: [workingCopy repository cloneFrom: url]
			ifCanceled: []].
	browser refresh.
	ToolBuilder open: browser