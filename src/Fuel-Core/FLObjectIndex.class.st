Class {
	#name : 'FLObjectIndex',
	#superclass : 'Object',
	#instVars : [
		'indexByObject',
		'objectByIndex'
	],
	#category : 'Fuel-Core-Collections',
	#package : 'Fuel-Core',
	#tag : 'Collections'
}

{ #category : 'enumerating' }
FLObjectIndex >> addNew: anObject [
	"Add anObject and answer true. But: Ignore if it was already added, and answer false."

	| wasAbsent |
	wasAbsent := false.

	"Maintain 2 collections. Each of them bring more efficient operations, depending on the case."
	indexByObject
		at: anObject
		ifAbsentPut: [
			wasAbsent := true.
			objectByIndex addLast: anObject.
			indexByObject size + 1 ].	
	
	^ wasAbsent 
]

{ #category : 'accessing' }
FLObjectIndex >> at: key ifPresent: aBlock [

	"#at: is much more efficient in IdentityDictionary than in OrderedCollection"
	^ indexByObject at: key ifPresent: aBlock
]

{ #category : 'enumerating' }
FLObjectIndex >> do: aBlock [

	"Note: #do: is much more efficient in OrderedCollection than in the IdentityDictionary"
	^ objectByIndex do: aBlock 
]

{ #category : 'initialization' }
FLObjectIndex >> initialize [

	super initialize.
	
	indexByObject := IdentityDictionary new.
	objectByIndex := OrderedCollection new
]

{ #category : 'accessing' }
FLObjectIndex >> size [

	^ indexByObject size
]

{ #category : 'sorting' }
FLObjectIndex >> sorted: aCleanBlockClosure [
	
	objectByIndex sort: aCleanBlockClosure.

	"Re-construct with the new order"
	indexByObject removeAll.
	objectByIndex withIndexDo: [ :each :index |
		indexByObject at: each put: index ]
]
