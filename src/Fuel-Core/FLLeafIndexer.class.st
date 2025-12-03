Class {
	#name : 'FLLeafIndexer',
	#superclass : 'Object',
	#instVars : [
		'indexByObject',
		'objectByIndex',
		'indexOffset'
	],
	#category : 'Fuel-Core-Collections',
	#package : 'Fuel-Core',
	#tag : 'Collections'
}

{ #category : 'enumerating' }
FLLeafIndexer >> do: aBlock [
	"Evaluate aBlock with each element as the argument, in addition order.

	Note: #do: is much more efficient in OrderedCollection than in the IdentityDictionary"

	^ objectByIndex do: aBlock 
]

{ #category : 'accessing' }
FLLeafIndexer >> indexOf: anObject ifPresent: aBlock [
	"Answer the index of a previously registered element. 
	
	Note: #at: is much more efficient in IdentityDictionary than in OrderedCollection"

	^ indexByObject at: anObject ifPresent: [ :index | aBlock value: index + indexOffset ]
]

{ #category : 'accessing' }
FLLeafIndexer >> indexOffset [

	^ indexOffset
]

{ #category : 'accessing' }
FLLeafIndexer >> indexOffset: anInteger [

	indexOffset := anInteger
]

{ #category : 'initialization' }
FLLeafIndexer >> initialize [

	super initialize.
	
	indexOffset := 0.
	indexByObject := IdentityDictionary new.
	objectByIndex := OrderedCollection new
]

{ #category : 'accessing' }
FLLeafIndexer >> lastIndex [

	^ indexOffset + self size
]

{ #category : 'enumerating' }
FLLeafIndexer >> register: anObject [
	"Add anObject as an element, and answer true. But: Ignore if it was already added, and answer false."

	| wasAdded |
	wasAdded := false.

	"Redundancy allows an improvement speed performance by taking the most efficient operations of each collection"
	indexByObject
		at: anObject
		ifAbsentPut: [
			wasAdded := true.
			objectByIndex addLast: anObject.
			indexByObject size + 1 ].	
	
	^ wasAdded 
]

{ #category : 'accessing' }
FLLeafIndexer >> size [

	^ indexByObject size
]

{ #category : 'sorting' }
FLLeafIndexer >> sort: aBlock [

	objectByIndex sort: aBlock.

	"Re-construct with the new order"
	indexByObject removeAll.
	objectByIndex withIndexDo: [ :each :index |
		indexByObject at: each put: index ]
]
