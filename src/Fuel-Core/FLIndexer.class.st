"
I'm a specialized dictionary for Fuel clusters that assigns a sequential order index to each added element.
"
Class {
	#name : 'FLIndexer',
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
FLIndexer >> do: aBlock [
	"Evaluate aBlock with each element as the argument, in addition order.

	Note: #do: is much more efficient in OrderedCollection than in the IdentitySet"

	^ objectByIndex do: aBlock 
]

{ #category : 'initialization' }
FLIndexer >> initialize [

	super initialize.
	
	objectSet := IdentitySet new.
	objectByIndex := OrderedCollection new
]

{ #category : 'enumerating' }
FLIndexer >> register: anObject [
	"Add anObject as an element, and answer true. But: Ignore if it was already added, and answer false."

	"Redundancy allows an improvement speed performance by taking the most efficient operations of each collection"
	objectSet
		addIfNotPresent: anObject
		ifPresentDo: [ ^ false ].	
	
	objectByIndex addLast: anObject.
	
	^ true
]

{ #category : 'accessing' }
FLIndexer >> size [

	^ objectByIndex size
]

{ #category : 'sorting' }
FLIndexer >> sort: aBlock [

	objectByIndex sort: aBlock
]

{ #category : 'enumerating' }
FLIndexer >> withIndexDo: aBlock [
	
	^ objectByIndex withIndexDo: aBlock
]
