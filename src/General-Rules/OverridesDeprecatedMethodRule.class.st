"
Checks if the method overrides a deprecated method. This is a sign that an API has changed in an upstream project and most likely the method should override another one.

This rule will not activate if the method itself is deprecated because it makes sens to deprecate the overriding methods of a deprecated method too.
"
Class {
	#name : 'OverridesDeprecatedMethodRule',
	#superclass : 'ReAbstractRule',
	#category : 'General-Rules-Potential Bugs',
	#package : 'General-Rules',
	#tag : 'Potential Bugs'
}

{ #category : 'testing' }
OverridesDeprecatedMethodRule class >> checksMethod [
	^ true
]

{ #category : 'accessing' }
OverridesDeprecatedMethodRule class >> group [
	^ self potentialBugsGroup
]

{ #category : 'accessing' }
OverridesDeprecatedMethodRule class >> ruleName [
	^ 'Overrides a deprecated method'
]

{ #category : 'accessing' }
OverridesDeprecatedMethodRule class >> uniqueIdentifierName [
	"This number should be unique and should change only when the rule completely change semantics"

	^ 'RBOverridesDeprecatedMethodRule'
]

{ #category : 'running' }
OverridesDeprecatedMethodRule >> basicCheck: aMethod [
	aMethod isDeprecated ifTrue: [ ^ false ].

	^ aMethod overriddenMethods anySatisfy: #isDeprecated
]
