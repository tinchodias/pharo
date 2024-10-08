"
I am the start of a literal array, normal literal arrays `#()` or byte arrays `#[]`.

"
Class {
	#name : 'ASTLiteralArrayToken',
	#superclass : 'ASTValueToken',
	#category : 'AST-Core-Tokens',
	#package : 'AST-Core',
	#tag : 'Tokens'
}

{ #category : 'testing' }
ASTLiteralArrayToken >> isForByteArray [
	^value last = $[
]

{ #category : 'testing' }
ASTLiteralArrayToken >> isLiteralArrayToken [
	^true
]
