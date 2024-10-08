"
I represent i386 architectures.
"
Class {
	#name : 'FFI_i386',
	#superclass : 'FFIArchitecture',
	#category : 'UnifiedFFI-Architecture',
	#package : 'UnifiedFFI',
	#tag : 'Architecture'
}

{ #category : 'testing' }
FFI_i386 class >> isActive [
	^ Smalltalk vm wordSize = 4
]

{ #category : 'callbacks' }
FFI_i386 >> newCallbackArgumentReaderForCallback: aCallback inContext: aCallbackContext [

	^ FFIi386CallbackArgumentReader
		forCallback: aCallback
		inContext: aCallbackContext
]

{ #category : 'default abi' }
FFI_i386 >> returnSingleFloatsAsDoubles [
	^ true
]
