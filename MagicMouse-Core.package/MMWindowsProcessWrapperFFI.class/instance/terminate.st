as yet unclassified
terminate
	CMFWinFFI terminateProcess: processInformation hProcess exitCode: 0.

	CMFWinFFI closeHandle: processInformation hThread.
	CMFWinFFI closeHandle: processInformation hProcess.

	CMFWinFFI closeHandle: (stdinRead getHandle unsignedLongLongAt: 1).
	CMFWinFFI closeHandle: (stdinWrite getHandle unsignedLongLongAt: 1).

	CMFWinFFI closeHandle: (stdoutRead getHandle unsignedLongLongAt: 1).
	CMFWinFFI closeHandle: (stdoutWrite getHandle unsignedLongLongAt: 1).

	stderrRead ifNotNil: [
		CMFWinFFI noError: [CMFWinFFI closeHandle: (stderrRead getHandle unsignedLongLongAt: 1)]].
	stderrWrite ifNotNil: [
		CMFWinFFI noError: [CMFWinFFI closeHandle: (stderrWrite getHandle unsignedLongLongAt: 1)]]