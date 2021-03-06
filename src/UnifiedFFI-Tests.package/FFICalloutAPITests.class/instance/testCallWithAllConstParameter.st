tests constant
testCallWithAllConstParameter
	"Tests a function in the form: 
	
	self nbCall: #( long ffiTestInts ( 65, 65, 65, long aNumber ) )
	
	(passing constants as parameters)
	"
	| result buffer |

	buffer := ByteArray new: 100. 
	result := self ffiTestConstantFormat: '%d, %d and %d' to: buffer.
	self assert: result equals: 12.
	self assert: (buffer first: result) asString equals: '65, 65 and 1'