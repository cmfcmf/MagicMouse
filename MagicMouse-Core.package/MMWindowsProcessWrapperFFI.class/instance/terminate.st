as yet unclassified
terminate
	CMFWinFFI terminateProcess: processInformation hProcess exitCode: 0.

	CMFWinFFI closeHandle: processInformation hThread.
	CMFWinFFI closeHandle: processInformation hProcess.

	[CMFWinFFI closeHandle: (stdinRead getHandle unsignedLongLongAt: 1)] ifError: [].
	[CMFWinFFI closeHandle: (stdinWrite getHandle unsignedLongLongAt: 1)] ifError: [].

	[CMFWinFFI closeHandle: (stdoutRead getHandle unsignedLongLongAt: 1)] ifError: [].
	[CMFWinFFI closeHandle: (stdoutWrite getHandle unsignedLongLongAt: 1)] ifError: [].

	[stderrRead ifNotNil: [CMFWinFFI closeHandle: (stderrRead getHandle unsignedLongLongAt: 1)]] ifError: [].
	[stderrWrite ifNotNil: [CMFWinFFI closeHandle: (stderrWrite getHandle unsignedLongLongAt: 1)]] ifError: []