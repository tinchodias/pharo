"
reify args
"
Class {
	#name : 'RFArgumentsReification',
	#superclass : 'RFReification',
	#category : 'Reflectivity-Reifications',
	#package : 'Reflectivity',
	#tag : 'Reifications'
}

{ #category : 'plugin interface' }
RFArgumentsReification class >> entities [
	^{ASTMessageNode. ASTMethodNode. ASTSequenceNode}
]

{ #category : 'plugin interface' }
RFArgumentsReification class >> key [
	^#arguments
]

{ #category : 'generate' }
RFArgumentsReification >> genForASTMessageNode [
	^ASTVariableNode named: self varName
]

{ #category : 'generate' }
RFArgumentsReification >> genForASTMethodNode [
	^ASTVariableNode named: self varName
]

{ #category : 'generate' }
RFArgumentsReification >> genForASTSequenceNode [
	^ASTVariableNode named: self varName
]

{ #category : 'preamble' }
RFArgumentsReification >> preambleForMessage: aNode [
	| preamble arguments |
	preamble := OrderedCollection new.
	arguments := OrderedCollection new.

	(1 to: aNode numArgs) reverseWithIndexDo: [:each :index |
			| name |
			name := 'RFArg', index asString, 'RFReification'.
			preamble add:  (RFStorePopIntoTempNode named: name).
	].

	(1 to: aNode numArgs) withIndexDo: [:each :index |
			| name |
			name := 'RFArg', index asString, 'RFReification'.
			arguments add:  (ASTVariableNode named: name).
	].
	preamble addAll: (ASTArrayNode statements: arguments).
	preamble add: (RFStorePopIntoTempNode named: self varName).
	preamble addAll: arguments.
	^ preamble
]

{ #category : 'preamble' }
RFArgumentsReification >> preambleForMethod: aNode [
	| preamble arguments |
	preamble := OrderedCollection new.
	arguments := aNode argumentNames collect: [ :name | ASTVariableNode named: name].
	preamble addAll: (ASTArrayNode statements: arguments).
	preamble add: (RFStorePopIntoTempNode named: self varName).
	^ preamble
]

{ #category : 'preamble' }
RFArgumentsReification >> preambleSequence: aNode [
	| preamble arguments |
	preamble := OrderedCollection new.
	arguments := aNode parent argumentNames collect: [ :name | ASTVariableNode named: name].
	preamble addAll: (ASTArrayNode statements: arguments).
	preamble add: (RFStorePopIntoTempNode named: self varName).
	^ preamble
]

{ #category : 'generate' }
RFArgumentsReification >> varName [
	^#RFArgumentsReificationVar
]
