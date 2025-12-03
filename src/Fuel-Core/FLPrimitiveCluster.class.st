"
I am a cluster that serializes and materializes interacting directly with the stream.
"
Class {
	#name : 'FLPrimitiveCluster',
	#superclass : 'FLIteratingCluster',
	#category : 'Fuel-Core-Clusters',
	#package : 'Fuel-Core',
	#tag : 'Clusters'
}

{ #category : 'analyzing' }
FLPrimitiveCluster class >> clusterBucketIn: aClusterization [

	^aClusterization primitivesBucket
]

{ #category : 'analyzing' }
FLPrimitiveCluster >> add: anObject traceWith: anAnalysis [
	"Add an object to the cluster. We know the object doesn't have references."

	objects register: anObject
]
