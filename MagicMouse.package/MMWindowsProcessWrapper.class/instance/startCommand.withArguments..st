as yet unclassified
startCommand: command withArguments: arguments
	self process: ProcessWrapper new.
	self process useStdout; useStderr.
	self process startWithShellCommand: command, ' ', (arguments joinSeparatedBy: ' '). 
	self process stdoutStream binary.
	self process stderrStream ascii.
	
	debug ifTrue: [Transcript clear.
		[[self process stderrStream atEnd] whileFalse: [
			Transcript show: self process stderrStream next]] fork].
	"debug ifTrue: [Transcript clear.
		[[self process stdoutStream atEnd] whileFalse: [
			Transcript show: self process stdoutStream next]] fork]"