"
Description
--------------------

I am a trait containing the behavior or retrieving the test class of a class.

If the test class does not exists I am able to generate it.
"
Trait {
	#name : 'TClyGenerateTestClass',
	#category : 'Calypso-SystemPlugins-SUnit-Browser-Traits',
	#package : 'Calypso-SystemPlugins-SUnit-Browser',
	#tag : 'Traits'
}

{ #category : 'action' }
TClyGenerateTestClass >> addNewCommentForTestClass: aClass basedOn: baseClass [
	aClass
		comment:
			(String
				streamContents: [ :stream |
					| name |
					name := aClass name.
					name first isVowel
						ifTrue: [ stream nextPutAll: 'An ' ]
						ifFalse: [ stream nextPutAll: 'A ' ].
					stream
						nextPutAll: name;
						nextPutAll: ' is a test class for testing the behavior of ';
						nextPutAll: baseClass name ])
]

{ #category : 'testing' }
TClyGenerateTestClass >> isValidClass: inputClass [
	^ (inputClass isTestCase or: [ inputClass isMeta ]) not
]

{ #category : 'accessing' }
TClyGenerateTestClass >> systemEnvironment [
	^ self explicitRequirement
]

{ #category : 'accessing' }
TClyGenerateTestClass >> testClassFor: inputClass [

	| className resultClass |
	className := self testClassNameFor: inputClass.
	self systemEnvironment classNamed: className ifPresent: [ :class | resultClass := class ] ifAbsent: [
		(self isValidClass: inputClass) ifFalse: [ ClyInvalidClassForTestClassGeneration signalFor: inputClass ].
		self systemEnvironment ensurePackage: inputClass package name asString , '-Tests'.

		resultClass := self class classInstaller make: [ :aBuilder |
			               aBuilder
				               name: className;
				               superclass: TestCase;
				               package: inputClass package name , '-Tests';
				               tag: inputClass packageTag name ].

		self addNewCommentForTestClass: resultClass basedOn: inputClass ].
	^ resultClass
]

{ #category : 'accessing' }
TClyGenerateTestClass >> testClassNameFor: inputClass [
	^ (inputClass name , 'Test') asSymbol
]
