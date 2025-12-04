Extension { #name : 'IdentitySet' }

{ #category : '*Fuel-Core' }
IdentitySet >> addIfNotPresent: anObject ifPresentDo: aBlock [
	"Include anObject as one of the receiver's elements and then value aBlock, but only if there
	is no such element already. Anwser anObject."

	| index |
	index := self scanFor: anObject.
	(array at: index) 
		ifNil: [self atNewIndex: index put: anObject asCollectionElement]
		ifNotNil: [ aBlock value ].
	^ anObject
]
