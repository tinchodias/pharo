"
I'm a specialized dictionary for Fuel clusters that assigns a sequential order index to each added element.
"
Class {
	#name : 'FLClusterIndexer',
	#superclass : 'Object',
	#instVars : [
		'objectByIndex',
		'objectSet'
	],
	#category : 'Fuel-Core-Collections',
	#package : 'Fuel-Core',
	#tag : 'Collections'
}

{ #category : 'enumerating' }
FLClusterIndexer >> do: aBlock [
	"Evaluate aBlock with each element as the argument, in addition order.

	Note: #do: is much more efficient in OrderedCollection than in the IdentitySet"

	^ objectByIndex do: aBlock 
]

{ #category : 'initialization' }
FLClusterIndexer >> initialize [

	super initialize.
	
	objectSet := IdentitySet new.
	objectByIndex := OrderedCollection new
]

{ #category : 'enumerating' }
FLClusterIndexer >> register: anObject [
	"Add anObject as an element, and answer true. But: Ignore if it was already added, and answer false."

	"Redundancy allows an improvement speed performance by taking the most efficient operations of each collection"
	objectSet
		addIfNotPresent: anObject
		ifPresentDo: [ ^ false ].	
	
	objectByIndex addLast: anObject.
	
	^ true
]

{ #category : 'accessing' }
FLClusterIndexer >> size [

	^ objectByIndex size
]

{ #category : 'sorting' }
FLClusterIndexer >> sort: aBlock [

	objectByIndex sort: aBlock
]

{ #category : 'enumerating' }
FLClusterIndexer >> withIndexDo: aBlock [
	
	^ objectByIndex withIndexDo: aBlock
]
