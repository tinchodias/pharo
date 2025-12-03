"
A FLCompositeIndexerTest is a test class for testing the behavior of FLCompositeIndexer
"
Class {
	#name : 'FLCompositeIndexerTest',
	#superclass : 'TestCase',
	#category : 'Fuel-Core-Tests-Collections',
	#package : 'Fuel-Core-Tests',
	#tag : 'Collections'
}

{ #category : 'tests' }
FLCompositeIndexerTest >> testComposition [

	| n m leaves composite |
	n := 4.
	m := 5.

	leaves := (1 to: m) collect: [ :j |
		| indexer start |
		indexer := FLLeafIndexer new.
		start := n * (j-1).
		1 to: n do: [ :i | indexer register: start + i ].
		indexer ].

	composite := FLCompositeIndexer new.
	leaves do: [ :indexer | composite registerChild: indexer ].

	self
		assert: ((1 to: n*m) collect: [ :i | composite indexOf: i ])
		equals: (1 to: n*m)
]
