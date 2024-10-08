"
I am a command to migrate references of a given class to another.

Internal Representation and Key Implementation Points.

Instance Variables
newName:  <String>
"
Class {
	#name : 'SycMigrateReferencesOfClassCommand',
	#superclass : 'SycSingleClassCommand',
	#instVars : [
		'newName'
	],
	#category : 'SystemCommands-ClassCommands',
	#package : 'SystemCommands-ClassCommands'
}

{ #category : 'converting' }
SycMigrateReferencesOfClassCommand >> asRefactorings [
	| refactoring |
	refactoring :=  RBDeprecateClassRefactoring deprecate: targetClass name in: newName name.
	refactoring shouldFixSubclasses: false.
	refactoring shouldCopyExtensions: false.
	refactoring shouldRemoveExtensions: false.
	^ { refactoring }
]

{ #category : 'accessing' }
SycMigrateReferencesOfClassCommand >> defaultMenuIconName [
	^ #source
]

{ #category : 'accessing' }
SycMigrateReferencesOfClassCommand >> defaultMenuItemName [
	^'Migrate references'
]

{ #category : 'execution' }
SycMigrateReferencesOfClassCommand >> execute [

	self asRefactorings do: [ :ref | ref execute ]
]

{ #category : 'testing' }
SycMigrateReferencesOfClassCommand >> isComplexRefactoring [
	^ true
]

{ #category : 'execution' }
SycMigrateReferencesOfClassCommand >> prepareFullExecutionInContext: aToolContext [

	super prepareFullExecutionInContext: aToolContext.
	newName := aToolContext requestSingleClass: 'Choose new class'
]
