"
ASTSearchRule is a parse tree rule that simply searches for matches to the rule. Every time a match is found, answerBlock is evaluated with the node that matches and the current answer. This two-argument approach allows a collection to be formed from all of the matches (Think inject:into:).

Instance Variables:
	answerBlock	<BlockClosure>	Block to evaluate with the matching node and the current answer.


"
Class {
	#name : 'ASTSearchRule',
	#superclass : 'ASTParseTreeRule',
	#instVars : [
		'answerBlock'
	],
	#category : 'AST-Core-Matching',
	#package : 'AST-Core',
	#tag : 'Matching'
}

{ #category : 'instance creation' }
ASTSearchRule class >> searchFor: aString thenDo: aBlock [
	^self new searchFor: aString thenDo: aBlock
]

{ #category : 'instance creation' }
ASTSearchRule class >> searchForMethod: aString thenDo: aBlock [
	^self new searchForMethod: aString thenDo: aBlock
]

{ #category : 'instance creation' }
ASTSearchRule class >> searchForTree: aBRProgramNode thenDo: aBlock [
	^self new searchForTree: aBRProgramNode thenDo: aBlock
]

{ #category : 'testing' }
ASTSearchRule >> canMatch: aProgramNode [
	owner answer: (answerBlock value: aProgramNode value: owner answer).
	^true
]

{ #category : 'private - searching' }
ASTSearchRule >> searchFor: aString thenDo: aBlock [
	self searchString: aString.
	answerBlock := aBlock
]

{ #category : 'private - searching' }
ASTSearchRule >> searchForMethod: aString thenDo: aBlock [
	self methodSearchString: aString.
	answerBlock := aBlock
]

{ #category : 'private - searching' }
ASTSearchRule >> searchForTree: aBRProgramNode thenDo: aBlock [
	searchTree := aBRProgramNode.
	answerBlock := aBlock
]
