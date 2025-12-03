"
I have the common behavior for generic storing and loading variable bits objects.
"
Class {
	#name : 'FLBitsObjectCluster',
	#superclass : 'FLObjectCluster',
	#category : 'Fuel-Core-Clusters',
	#package : 'Fuel-Core',
	#tag : 'Clusters'
}

{ #category : 'analyzing' }
FLBitsObjectCluster >> add: anObject traceWith: anAnalysis [
	"Add an object to the cluster. We know the object doesn't have references."

	objects register: anObject
]
