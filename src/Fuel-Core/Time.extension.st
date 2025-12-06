Extension { #name : 'Time' }

{ #category : '*Fuel-Core' }
Time >> fuelAccept: aGeneralMapper [

	^ aGeneralMapper visitHookPrimitive: self
]

{ #category : '*Fuel-Core' }
Time class >> materializeFrom: aDecoder [
	
	^ self
		seconds: aDecoder nextEncodedPositiveInteger
		nanoSeconds: aDecoder nextEncodedPositiveInteger
]

{ #category : '*Fuel-Core' }
Time >> serializeOn: anEncoder [

	anEncoder 
		encodePositiveInteger: self asSeconds;
		encodePositiveInteger: self nanoSecond
]
