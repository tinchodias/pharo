Class {
	#name : 'FLCompositeIndex',
	#superclass : 'Object',
	#instVars : [
		'indices'
	],
	#category : 'Fuel-Core-Collections',
	#package : 'Fuel-Core',
	#tag : 'Collections'
}

{ #category : 'registry' }
FLCompositeIndex >> addAll: anObjectIndex [
	"We assume the received index will not change anymore."

	| newEntry |
	newEntry := indices
		ifEmpty: [ { 0. anObjectIndex } ]
		ifNotEmpty: [ { indices last first + indices last second size. anObjectIndex } ].

	indices add: newEntry
]

{ #category : 'accessing' }
FLCompositeIndex >> at: key [

	^ self
		at: key
		ifAbsent: [
			KeyNotFound new
				collection: self;
				key: key;
				signal ]
]

{ #category : 'accessing' }
FLCompositeIndex >> at: key ifAbsent: aBlock [

	indices do: [ :each |
		each second at: key ifPresent: [ :v | ^ v + each first ] ].

	^ aBlock value
]

{ #category : 'initialization' }
FLCompositeIndex >> initialize [

	super initialize.
	
	indices := OrderedCollection new
]
