"
I have shared behavior of some optional clusters.
"
Class {
	#name : 'FLOptimizedObjectCluster',
	#superclass : 'FLIteratingCluster',
	#category : 'Fuel-Core-Clusters-Optimized',
	#package : 'Fuel-Core',
	#tag : 'Clusters-Optimized'
}

{ #category : 'analyzing' }
FLOptimizedObjectCluster class >> clusterBucketIn: aClusterization [

	^aClusterization baselevelBucket
]

{ #category : 'serialize/materialize' }
FLOptimizedObjectCluster >> materializeReferencesOf: anObject with: aDecoder [
	"Hook method"

	self subclassResponsibility
]

{ #category : 'serialize/materialize' }
FLOptimizedObjectCluster >> materializeReferencesStepWith: aDecoder [

	objects do: [ :anObject | self materializeReferencesOf: anObject with: aDecoder ]
]

{ #category : 'serialize/materialize' }
FLOptimizedObjectCluster >> serializeInstancesStepWith: anEncoder [
	"Do nothing. I know my objects have nothing to serialize in this step."
]

{ #category : 'serialize/materialize' }
FLOptimizedObjectCluster >> serializeReferencesOf: anObject with: anEncoder [

	self 
		referencesOf: anObject 
		do: [ :each | anEncoder encodeReferenceTo: each ]
]

{ #category : 'serialize/materialize' }
FLOptimizedObjectCluster >> serializeReferencesStepWith: anEncoder [

	objects do: [ :anObject | self serializeReferencesOf: anObject with: anEncoder ]
]
