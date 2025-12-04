"
I'm a specialized dictionary for Fuel encoder that is efficient for aggregating the elements of clusters.
"
Class {
	#name : 'FLEncoderIndexer',
	#superclass : 'Object',
	#instVars : [
		'indexByObject'
	],
	#category : 'Fuel-Core-Collections',
	#package : 'Fuel-Core',
	#tag : 'Collections'
}

{ #category : 'instance creation' }
FLEncoderIndexer class >> new: numberOfElements [

	^ self basicNew
		initialize: numberOfElements;
		yourself

]

{ #category : 'accessing' }
FLEncoderIndexer >> indexOf: anObject [

	^ indexByObject at: anObject
]

{ #category : 'accessing' }
FLEncoderIndexer >> indexOf: anObject ifAbsent: aBlock [

	^ indexByObject at: anObject ifAbsent: aBlock
]

{ #category : 'initialization' }
FLEncoderIndexer >> initialize: numberOfElements [

	self initialize.
	
	indexByObject := IdentityDictionary new: numberOfElements
]

{ #category : 'printing' }
FLEncoderIndexer >> printOn: aStream [

	super printOn: aStream.
	
	aStream
		nextPut: $(;
		print: self size;
		nextPut: $)
]

{ #category : 'registry' }
FLEncoderIndexer >> registerAll: anIndexer [

	| offset |
	offset := indexByObject size.

	anIndexer withIndexDo: [ :anObject :index |
		indexByObject at: anObject put: index + offset ]
]

{ #category : 'accessing' }
FLEncoderIndexer >> size [

	^ indexByObject size
]
