starting
startCommand: command withArguments: arguments

	self process: ProcessWrapper new.
	self process
		useStdout;
		useStderr.
	self flag: #todo.
	"Properly escape arguments"
	self process startWithShellCommand: command, ' ', ((arguments collect: [:arg | '"', arg, '"']) joinSeparatedBy: ' ').
	self process stdoutStream binary.
	self process stderrStream ascii.
	
	debug ifTrue: [
		Transcript clear.
		[[self process stderrStream atEnd] whileFalse: [Transcript show: self process stderrStream next]] fork]