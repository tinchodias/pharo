"
This Warning is signalled by methods which are deprecated.

Idiom: Imagine I want to deprecate the message #foo.

foo
	^ 'foo'

I can replace it with:

foo
	self 
		deprecated:   'The method #foo was not good. Use Bar>>newFoo instead.'
		on:  'here add date'
		in:  'here add version'
		 transformWith:   '`@receiver foo' -> '`@receiver newFoo'.	
	^self newFoo
	
	
The  transformWith:  part is optional. It allows to transform the deprecated method automatically when called.
If the transformation is defined, the Warning will not signalled.


"
Class {
	#name : 'BackwardCompatibility',
	#superclass : 'AutomaticRewriting',
	#instVars : [
		'context',
		'explanationString',
		'deprecationDate',
		'versionString',
		'rule',
		'condition'
	],
	#classVars : [
		'Active',
		'Log',
		'RaiseWarning',
		'ShowWarning'
	],
	#category : 'Kernel-Exceptions',
	#package : 'Kernel',
	#tag : 'Exceptions'
}

{ #category : 'logging' }
BackwardCompatibility class >> activateTransformations [

	^ Active ifNil: [ Active := true ]
]

{ #category : 'logging' }
BackwardCompatibility class >> activateTransformations: aBoolean [

	Active := aBoolean
]

{ #category : 'logging' }
BackwardCompatibility class >> deprecationsWhile: aBlock [
	"returns a log of all deprecated methods seen while executing aBlock"
	| oldLog result |
	oldLog := Log.
	Log := Set new.
	aBlock value.
	result := Log.
	oldLog ifNotNil: [oldLog addAll: result].
	Log := oldLog.
	^result
]

{ #category : 'class initialization' }
BackwardCompatibility class >> initialize [
	self reset
]

{ #category : 'settings' }
BackwardCompatibility class >> raiseWarning [
	"If true, then a dialog is popup for each deprecated method invocation"
	^ RaiseWarning ifNil: [RaiseWarning := false]
]

{ #category : 'settings' }
BackwardCompatibility class >> raiseWarning: aBoolean [
	RaiseWarning := aBoolean
]

{ #category : 'class initialization' }
BackwardCompatibility class >> reset [
	<script>
	Log := nil.
	RaiseWarning := nil.
	ShowWarning := nil.
	Active := nil
]

{ #category : 'settings' }
BackwardCompatibility class >> showWarning [
	"If true, then a message is send to the Transcript for each deprecated method invocation"
	^ ShowWarning ifNil: [ShowWarning := true]
]

{ #category : 'settings' }
BackwardCompatibility class >> showWarning: aBoolean [
	ShowWarning := aBoolean
]

{ #category : 'comparing' }
BackwardCompatibility >> = anObject [
	^self class == anObject class
	  and: [context = anObject contextOfDeprecatedMethod
	  and: [context
			ifNil: [explanationString = anObject explanationString]
			ifNotNil: [true]]]
]

{ #category : 'accessing' }
BackwardCompatibility >> condition: aBlock [
	condition := aBlock
]

{ #category : 'accessing' }
BackwardCompatibility >> context: aContext [
	context := aContext
]

{ #category : 'accessing' }
BackwardCompatibility >> contextOfDeprecatedMethod [
	^context
]

{ #category : 'accessing' }
BackwardCompatibility >> contextOfSender [
	^context home sender
]

{ #category : 'accessing' }
BackwardCompatibility >> date: aDate [
	deprecationDate := aDate
]

{ #category : 'handling' }
BackwardCompatibility >> defaultAction [

	Log ifNotNil: [ :log | log add: self ].
	self showWarning ifTrue: [ self logTranscript ].
	self raiseWarning ifTrue: [ super defaultAction ].
	self shouldTransform ifTrue: [ self transform ]
]

{ #category : 'private' }
BackwardCompatibility >> deprecatedMethodName [
	^self contextOfDeprecatedMethod homeMethod printString
]

{ #category : 'accessing' }
BackwardCompatibility >> deprecationDate [

	^ deprecationDate ifNil: [ 'unknown' ]
]

{ #category : 'accessing' }
BackwardCompatibility >> explanation: aString [
	explanationString := aString
]

{ #category : 'accessing' }
BackwardCompatibility >> explanationString [

	^ explanationString
]

{ #category : 'comparing' }
BackwardCompatibility >> hash [
	^(context ifNil: [explanationString]) hash
]

{ #category : 'private' }
BackwardCompatibility >> logTranscript [
	DeprecationPerformedNotification signal: self messageText
]

{ #category : 'accessing' }
BackwardCompatibility >> messageText [
	^String streamContents: [ :str |
		self shouldTransform ifTrue: [
			str nextPutAll:  'Automatic deprecation code rewrite: '].
		str
			nextPutAll: 'The method ';
			nextPutAll: self deprecatedMethodName;
			nextPutAll: ' called from ';
			nextPutAll: self sendingMethodName;
			nextPutAll: ' has been deprecated. ';
		 	nextPutAll: explanationString]
]

{ #category : 'settings' }
BackwardCompatibility >> raiseWarning [
	^ self class raiseWarning
]

{ #category : 'private' }
BackwardCompatibility >> rewriterClass [
	^ self class environment at: #ASTParseTreeRewriter ifAbsent: [ nil ]
]

{ #category : 'accessing' }
BackwardCompatibility >> rule: aRule [
	rule := aRule
]

{ #category : 'private' }
BackwardCompatibility >> sendingMethodName [
	^self contextOfSender homeMethod printString
]

{ #category : 'handling' }
BackwardCompatibility >> shouldTransform [
	self class activateTransformations ifFalse: [ ^false  ].
	(condition isNil or: [ condition cull: self ]) ifFalse: [ ^false ].
	^rule isNotNil
]

{ #category : 'settings' }
BackwardCompatibility >> showWarning [
	^ self class showWarning
]

{ #category : 'handling' }
BackwardCompatibility >> signal [
	| pragma homeMethod |
	homeMethod := context homeMethod.
	(homeMethod hasPragmaNamed: #transform:to:) ifFalse: [ ^super signal ].

	pragma := homeMethod pragmaAt: #transform:to:.
	self rule: pragma arguments first -> pragma arguments second.
	self transform
]

{ #category : 'handling' }
BackwardCompatibility >> transform [

	| node rewriteRule aMethod |

	self rewriterClass ifNil:[ ^ self ].
	aMethod := self contextOfSender homeMethod.
	
	"no need to transform doits or non installed methods.
	Non installed methods can arise if we are rewriting a closure whose home method was rewritten"
	aMethod isDoIt ifTrue:[ ^ self ].
	aMethod isInstalled ifFalse: [ ^ self ].
	
	node := self contextOfSender sourceNodeExecuted.
	RecursionStopper during: [
		rewriteRule := self rewriterClass new
			replace: rule key with: rule value.
		(rewriteRule executeTree: node)
			ifFalse: [ ^ self ].
		node replaceWith: rewriteRule tree.
		aMethod origin
			compile: aMethod ast formattedCode
			classified: aMethod protocol.
		Log ifNotNil: [ :log | log add: self ] ]
]

{ #category : 'accessing' }
BackwardCompatibility >> version: aString [
	versionString := aString
]

{ #category : 'accessing' }
BackwardCompatibility >> versionString [

	^ versionString ifNil: [ 'unknown' ]
]
