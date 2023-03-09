Extension { #name : #ZnUTF8Encoder }

{ #category : #'*Ombu' }
ZnUTF8Encoder >> skipToValidCharacterOnStream: stream [
	"Ensure that the current position of stream is a the beginning of an encoded code point,
	if not move further forward. This is necessary when a position in the binary stream is set,
	not knowing if that position is on a proper encoded character boundary."

	[ (stream peek bitAnd: 2r11000000) == 2r10000000 ] whileTrue: [ stream next ]
]
