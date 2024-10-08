"
ASTPatternVariableNode is an AST node that is used to match several other types of nodes (literals, variables, value nodes, statement nodes, and sequences of statement nodes).

The different types of matches are determined by the name of the node. If the name contains a # character, then it will match a literal. If it contains, a . then it matches statements. If it contains no extra characters, then it matches only variables. These options are mutually exclusive.

The @ character can be combined with the name to match lists of items. If combined with the . character, then it will match a list of statement nodes (0 or more). If used without the . or # character, then it matches anything except for a list of statements. Combining the @ with the # is not supported.

Adding another ` in the name will cause the search/replace to look for more matches inside the node that this node matched. This option should not be used for top-level expressions since that would cause infinite recursion (e.g., searching only for ""``@anything"").

Instance Variables:
	isAnything	<Boolean>	can we match any type of node
	isList	<Boolean>	can we match a list of items (@)
	isLiteral	<Boolean>	only match a literal node (#)
	isStatement	<Boolean>	only match statements (.)
	recurseInto	<Boolean>	search for more matches in the node we match (`)


"
Class {
	#name : 'ASTPatternVariableNode',
	#superclass : 'ASTVariableNode',
	#instVars : [
		'recurseInto',
		'isList',
		'isLiteral',
		'isStatement',
		'isAnything'
	],
	#category : 'AST-Core-Pattern',
	#package : 'AST-Core',
	#tag : 'Pattern'
}

{ #category : 'instance creation' }
ASTPatternVariableNode class >> identifierNamed: anIdentifierName at: aPosition [
	^anIdentifierName isPatternVariable
		ifTrue: [super identifierNamed: anIdentifierName at: aPosition]
		ifFalse: [ASTVariableNode identifierNamed: anIdentifierName at: aPosition]
]

{ #category : 'verification' }
ASTPatternVariableNode >> compare: anObject with: aNode [
	^ anObject isCollection
		ifTrue: [ anObject anySatisfy: [ :e | e = aNode ] ]
		ifFalse: [ anObject = aNode ]
]

{ #category : 'matching' }
ASTPatternVariableNode >> copyInContext: aDictionary [
	^ (self isList and: [ self isStatement ])
		ifTrue: [ self copyList: (aDictionary at: self) inContext: aDictionary ]
		ifFalse: [ (aDictionary at: self) copy ]
]

{ #category : 'initialization' }
ASTPatternVariableNode >> initializePatternVariables [
	| myname |
	myname := self name.
	isAnything := isList := isLiteral := isStatement := recurseInto := false.
	2 to: myname size
		do:
			[:i |
			| character |
			character := myname at: i.
			character == self listCharacter
				ifTrue: [isAnything := isList := true]
				ifFalse:
					[character == self literalCharacter
						ifTrue: [isLiteral := true]
						ifFalse:
							[character == self statementCharacter
								ifTrue: [isStatement := true]
								ifFalse:
									[character == self recurseIntoCharacter
										ifTrue: [recurseInto := true]
										ifFalse: [^self]]]]]
]

{ #category : 'testing - matching' }
ASTPatternVariableNode >> isAnything [
	^isAnything
]

{ #category : 'testing - matching' }
ASTPatternVariableNode >> isList [
	^isList
]

{ #category : 'testing - matching' }
ASTPatternVariableNode >> isLiteralNode [
	^isLiteral
]

{ #category : 'testing - matching' }
ASTPatternVariableNode >> isPatternNode [
	^true
]

{ #category : 'testing - matching' }
ASTPatternVariableNode >> isStatement [
	^isStatement
]

{ #category : 'matching' }
ASTPatternVariableNode >> match: aNode inContext: aDictionary [
	self isAnything
		ifTrue: [^ self compare: (aDictionary at: self ifAbsentPut: [aNode]) with: aNode].
	self isLiteralNode ifTrue: [^self matchLiteral: aNode inContext: aDictionary].
	self isStatement
		ifTrue: [^self matchStatement: aNode inContext: aDictionary].
	(aNode isKindOf: self matchingClass) ifFalse: [^false].
	^ self compare: (aDictionary at: self ifAbsentPut: [aNode]) with: aNode
]

{ #category : 'matching' }
ASTPatternVariableNode >> matchLiteral: aNode inContext: aDictionary [

	^aNode isLiteralNode
		and: [ self compare: (aDictionary at: self ifAbsentPut: [aNode]) with: aNode]
]

{ #category : 'matching' }
ASTPatternVariableNode >> matchStatement: aNode inContext: aDictionary [
	(aNode parent isNotNil and: [aNode parent isSequence]) ifFalse: [^false].
	^ self compare: (aDictionary at: self ifAbsentPut: [aNode]) with: aNode
]

{ #category : 'private' }
ASTPatternVariableNode >> matchingClass [
	^ASTVariableNode
]

{ #category : 'initialization' }
ASTPatternVariableNode >> named: aName start: aPosition [

	super named: aName start: aPosition.
	self initializePatternVariables
]

{ #category : 'accessing' }
ASTPatternVariableNode >> parent: aBRProgramNode [
	"Fix the case where '``@node' should match a single node, not a sequence node."

	super parent: aBRProgramNode.
	parent isDynamicArray
		ifTrue: [ self isStatement
				ifFalse: [ isList := false ] ].
	parent isSequence
		ifTrue:
			[(self isStatement or: [parent temporaries includes: self])
				ifFalse: [isList := false]]
]

{ #category : 'testing - matching' }
ASTPatternVariableNode >> recurseInto [
	^recurseInto
]
