"
ASTReadBeforeWrittenTester is a visitor that identifies variables that may have been read before they are initialized.

Instance Variables:
	checkNewTemps	<Boolean>	description of checkNewTemps
	read	<Collection>	description of read
	scopeStack	<OrderedCollection>	description of scopeStack


"
Class {
	#name : 'ASTReadBeforeWrittenTester',
	#superclass : 'ASTProgramNodeVisitor',
	#instVars : [
		'read',
		'checkNewTemps',
		'scopeStack'
	],
	#category : 'AST-Core-Visitors',
	#package : 'AST-Core',
	#tag : 'Visitors'
}

{ #category : 'accessing' }
ASTReadBeforeWrittenTester class >> isVariable: aString readBeforeWrittenIn: aBRProgramNode [
	^(self isVariable: aString writtenBeforeReadIn: aBRProgramNode) not
]

{ #category : 'accessing' }
ASTReadBeforeWrittenTester class >> isVariable: aString writtenBeforeReadIn: aBRProgramNode [
	^(self readBeforeWritten: (Array with: aString) in: aBRProgramNode)
		isEmpty
]

{ #category : 'accessing' }
ASTReadBeforeWrittenTester class >> readBeforeWritten: varNames in: aParseTree [
	^(self new)
		checkNewTemps: false;
		initializeVars: varNames;
		executeTree: aParseTree;
		read
]

{ #category : 'accessing' }
ASTReadBeforeWrittenTester class >> variablesReadBeforeWrittenIn: aParseTree [
	^(self new)
		executeTree: aParseTree;
		read
]

{ #category : 'initialization' }
ASTReadBeforeWrittenTester >> checkNewTemps: aBoolean [
	checkNewTemps := aBoolean
]

{ #category : 'private' }
ASTReadBeforeWrittenTester >> copyDictionary: aDictionary [
	"We could send aDictionary the copy message, but that doesn't copy the associations."

	| newDictionary |
	newDictionary := Dictionary new: aDictionary size.
	aDictionary keysAndValuesDo: [ :key :value | newDictionary at: key put: value ].
	^ newDictionary
]

{ #category : 'private' }
ASTReadBeforeWrittenTester >> createScope [
	scopeStack add: (self copyDictionary: scopeStack last)
]

{ #category : 'private' }
ASTReadBeforeWrittenTester >> currentScope [
	^scopeStack last
]

{ #category : 'accessing' }
ASTReadBeforeWrittenTester >> executeTree: aParseTree [
	^self visitNode: aParseTree
]

{ #category : 'initialization' }
ASTReadBeforeWrittenTester >> initialize [
	super initialize.
	scopeStack := OrderedCollection with: Dictionary new.
	read := Set new.
	checkNewTemps := true
]

{ #category : 'initialization' }
ASTReadBeforeWrittenTester >> initializeVars: varNames [
	varNames do: [:each | self currentScope at: each put: nil]
]

{ #category : 'private' }
ASTReadBeforeWrittenTester >> processBlock: aNode [
	| newScope |
	self createScope.
	self executeTree: aNode body.
	newScope := self removeScope.
	newScope keysAndValuesDo:
			[:key :value |
			(value == true and: [(self currentScope at: key) isNil])
				ifTrue: [self currentScope at: key put: value]]
]

{ #category : 'private' }
ASTReadBeforeWrittenTester >> processIfTrueIfFalse: aNode [

	| trueScope falseScope |

	self createScope.
	self executeTree: aNode arguments first body.
	trueScope := self removeScope.
	self createScope.
	self executeTree: aNode arguments last body.
	falseScope := self removeScope.
	self currentScope
		keysAndValuesDo: [ :key :value |
			value
				ifNil: [ ( trueScope at: key ) == ( falseScope at: key )
						ifTrue: [ self currentScope at: key put: ( trueScope at: key ) ]
						ifFalse: [ ( ( trueScope at: key ) == true or: [ ( falseScope at: key ) == true ] )
								ifTrue: [ self currentScope at: key put: true ]
							]
					]
			]
]

{ #category : 'private' }
ASTReadBeforeWrittenTester >> processStatementNode: aNode [

	| temps |

	( checkNewTemps not or: [ aNode temporaries isEmpty ] )
		ifTrue: [ aNode statements do: [ :each | self executeTree: each ].
			^ self
			].
	self createScope.
	temps := aNode temporaries collect: [ :each | each name ].
	self initializeVars: temps.
	aNode statements do: [ :each | self executeTree: each ].
	self removeScope
		keysAndValuesDo: [ :key :value |
			( temps includes: key )
				ifTrue: [ value == true
						ifTrue: [ read add: key ]
					]
				ifFalse: [ ( self currentScope at: key ) ifNil: [ self currentScope at: key put: value ] ]
			]
]

{ #category : 'accessing' }
ASTReadBeforeWrittenTester >> read [
	self currentScope
		keysAndValuesDo: [:key :value | value == true ifTrue: [read add: key]].
	^read
]

{ #category : 'private' }
ASTReadBeforeWrittenTester >> removeScope [
	^scopeStack removeLast
]

{ #category : 'private' }
ASTReadBeforeWrittenTester >> variableRead: aNode [

	( self currentScope includesKey: aNode name )
		ifTrue: [ ( self currentScope at: aNode name ) ifNil: [ self currentScope at: aNode name put: true ] ]
]

{ #category : 'private' }
ASTReadBeforeWrittenTester >> variableWritten: aNode [

	( self currentScope includesKey: aNode variable name )
		ifTrue: [ ( self currentScope at: aNode variable name )
				ifNil: [ self currentScope at: aNode variable name put: false ]
			]
]

{ #category : 'visiting' }
ASTReadBeforeWrittenTester >> visitAssignmentNode: anAssignmentNode [
	self visitNode: anAssignmentNode value.
	self variableWritten: anAssignmentNode
]

{ #category : 'visiting' }
ASTReadBeforeWrittenTester >> visitBlockNode: aBlockNode [
	self processBlock: aBlockNode
]

{ #category : 'visiting' }
ASTReadBeforeWrittenTester >> visitMessageNode: aMessageNode [
	((#(#whileTrue: #whileFalse: #whileTrue #whileFalse #whileNil:)
		includes: aMessageNode selector) and: [aMessageNode receiver isBlock])
		ifTrue: [self executeTree: aMessageNode receiver body]
		ifFalse:
			[(aMessageNode isCascaded not or: [aMessageNode isFirstCascaded])
				ifTrue: [self visitNode: aMessageNode receiver]].
	((#(#ifTrue:ifFalse: #ifFalse:ifTrue:) includes: aMessageNode selector)
		and: [aMessageNode arguments allSatisfy: [:each | each isBlock]])
			ifTrue: [^self processIfTrueIfFalse: aMessageNode].
	aMessageNode arguments do: [:each | self visitNode: each]
]

{ #category : 'visiting' }
ASTReadBeforeWrittenTester >> visitSequenceNode: aSequenceNode [
	self processStatementNode: aSequenceNode
]

{ #category : 'visiting' }
ASTReadBeforeWrittenTester >> visitVariableNode: aVariableNode [
	self variableRead: aVariableNode
]
