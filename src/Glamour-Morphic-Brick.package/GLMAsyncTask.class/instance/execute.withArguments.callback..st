async
execute: aBlock withArguments: aCollection callback: callbackBlock
	"execution happens with UI process priority so that communication with UI can be done in real time"
	
	^ self
		execute: aBlock
		withArguments: aCollection
		callback: callbackBlock
		priority: Processor userSchedulingPriority