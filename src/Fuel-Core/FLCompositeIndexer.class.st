Class {
	#name : 'FLCompositeIndexer',
	#superclass : 'Object',
	#instVars : [
		'children'
	],
	#category : 'Fuel-Core-Collections',
	#package : 'Fuel-Core',
	#tag : 'Collections'
}

{ #category : 'accessing' }
FLCompositeIndexer >> indexOf: anObject [

	^ self
		indexOf: anObject
		ifAbsent: [
			KeyNotFound new
				collection: self;
				key: anObject;
				signal ]
]

{ #category : 'accessing' }
FLCompositeIndexer >> indexOf: anObject ifAbsent: aBlock [

	children do: [ :each |
		each indexOf: anObject ifPresent: [ :index | ^ index ] ].

	^ aBlock value
]

{ #category : 'initialization' }
FLCompositeIndexer >> initialize [

	super initialize.
	
	children := OrderedCollection new
]

{ #category : 'registry' }
FLCompositeIndexer >> registerChild: anIndexer [
	"Add an indexer as an internal collaborator. Children do not change anymore."

	children ifNotEmpty: [
		anIndexer indexOffset: children last lastIndex ].

	children addLast: anIndexer
]
