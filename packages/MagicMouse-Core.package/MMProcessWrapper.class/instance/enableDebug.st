accessing
enableDebug
	"Enable debugging to the Transcript. Must be called before a process is started."

	debug := true.
	Transcript class forceUpdate ifTrue: [Transcript show: 'WARNING: The "Force transcript updates to screen" preference is enabled. Consider to disable it to improve performance.']