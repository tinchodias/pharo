Extension { #name : 'Float' }

{ #category : '*Fuel-Core' }
Float >> fuelAccept: aGeneralMapper [

	^aGeneralMapper visitHookPrimitive: self
]

{ #category : '*Fuel-Core' }
Float class >> materializeFrom: aDecoder [
	"The * 1 is here to give a chance to the VM to create a SmallFloat64 if it can (thanks Nicolas Cellier)."
	
	^ (BoxedFloat64 new: 2)
		at: 1 put: aDecoder nextEncodedPositiveInteger;
		at: 2 put: aDecoder nextEncodedPositiveInteger;
		* 1
]

{ #category : '*Fuel-Core' }
Float >> serializeOn: anEncoder [

	anEncoder 
		encodePositiveInteger: (self at: 1);
		encodePositiveInteger: (self at: 2)
]
