"
I represent a FreeType face.

I expand the external object API of my superclass with useful protocol, and provide instance sharing protocol in class-side.

"
Class {
	#name : #FreeTypeFace,
	#superclass : #FT2Face,
	#instVars : [
		'filename',
		'index',
		'fileContentsExternalMemory',
		'hasKerning'
	],
	#classInstVars : [
		'instancesWeakSet'
	],
	#category : #'FreeType-Fonts'
}

{ #category : #'instance creation' }
FreeTypeFace class >> fromBytes: aByteArray index: anInteger [
	"share alike instances"
	
	^ self instancesWeakSet
		detect: [ :face |
			face fileContentsExternalMemoryBytes = aByteArray and: [
			face index = anInteger] ]
		ifNone:[ 
			self newInWeakSet
				fileContentsExternalMemory: (FreeTypeExternalMemory bytes: aByteArray);
				index: anInteger;
				autoRelease;
				yourself ]

]

{ #category : #'instance creation' }
FreeTypeFace class >> fromFile: aFileName index: anInteger [
	"share alike instances"

	^ self instancesWeakSet
		detect: [ :face |
			face filename = aFileName and: [
			face index = anInteger] ]
		ifNone:[
			self newInWeakSet
				filename: aFileName;
				index: anInteger;
				autoRelease;
				yourself ]

]

{ #category : #'instance creation' }
FreeTypeFace class >> instancesWeakSet [

	^ instancesWeakSet ifNil: [ 
		  instancesWeakSet := WeakSet new
			         addAll: self allInstances;
			         yourself ]
]

{ #category : #'instance creation' }
FreeTypeFace class >> newInWeakSet [

	| anInstance |
	anInstance := self basicNew.
	self instancesWeakSet add: anInstance.
	^ anInstance
]

{ #category : #initialization }
FreeTypeFace >> actAsExecutor [
	super actAsExecutor.
	filename := '<finalizer>'.
]

{ #category : #validation }
FreeTypeFace >> create [
	"create me in FT2. This gets my handle, and loads the fields"
	
	fileContentsExternalMemory 
		ifNotNil: [ self newFaceFromExternalMemory: fileContentsExternalMemory index: index ]	
		ifNil: [	self newFaceFromFile: filename asFileReference index: index ].
			
	self loadFields.
]

{ #category : #accessing }
FreeTypeFace >> familyName [
	^super familyName ifNil:['?']
]

{ #category : #accessing }
FreeTypeFace >> fileContentsExternalMemory: aFreeTypeExternalMemory [
	fileContentsExternalMemory := aFreeTypeExternalMemory
]

{ #category : #accessing }
FreeTypeFace >> fileContentsExternalMemoryBytes [
	^fileContentsExternalMemory ifNotNil:[fileContentsExternalMemory bytes]
]

{ #category : #accessing }
FreeTypeFace >> filename [
	^filename
]

{ #category : #accessing }
FreeTypeFace >> filename: aString [
	filename := aString
]

{ #category : #testing }
FreeTypeFace >> hasFamilyName [
	^super familyName notNil
]

{ #category : #testing }
FreeTypeFace >> hasKerning [
	"FT_FACE_FLAG_KERNING = 64 (1 << 6)"

	^ hasKerning ifNil: [ hasKerning := (faceFlags bitAnd: 64) = 64 ]
]

{ #category : #testing }
FreeTypeFace >> hasStyleName [
	^super styleName notNil
]

{ #category : #accessing }
FreeTypeFace >> index [
	^index
]

{ #category : #accessing }
FreeTypeFace >> index: anInteger [
	index := anInteger
]

{ #category : #copying }
FreeTypeFace >> postCopy [ 

	handle beNull.
	self validate.
	self autoRelease.
	^ self
]

{ #category : #caching }
FreeTypeFace >> releaseCachedState [

	hasKerning := nil.
]

{ #category : #accessing }
FreeTypeFace >> styleName [
	^super styleName ifNil:['']
]

{ #category : #validation }
FreeTypeFace >> validate [
	"If the receiver is not valid (has a nil handle), then create the 
	receiver to obtain a handle and load the receiver's fields"
	
	(self isValid 
		and: [ numCharmaps notNil ]) 
		ifTrue: [ ^ self ].
	
	self create
]
