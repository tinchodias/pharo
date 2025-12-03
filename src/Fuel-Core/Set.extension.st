Extension { #name : 'Set' }

{ #category : '*Fuel-Core' }
Set >> fuelAccept: aGeneralMapper [
	"Since we have subclasses of Set that behave differently, we cannot use the visitSimpleCollection: for all of them."
	^ ((self class == Set) or: [ self class == IdentitySet ] ) 
		ifTrue: [ aGeneralMapper visitSimpleCollection: self ]
		ifFalse: [ super fuelAccept: aGeneralMapper ]
]

{ #category : '*Fuel-Core' }
Set >> fuelAfterMaterialization [

	"Since for Set and IdentitySet we are recreating the collection with #add: (see FLSimpleCollectionCluster) we do not need to rehash"
	^ ((self class == Set) or: [ self class == IdentitySet ] ) 
		ifFalse: [ self rehash ] 
		ifTrue: [ self ]
]
