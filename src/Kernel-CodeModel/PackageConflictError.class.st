"
I'm an error that happens when someone attempts to register a package with a conflicting name. 
Conflicting names can be of two ways: 

PackageA(tagB) conflicts with PackageA-B
PackageA-B conflicts with PackageA(tagB)
"
Class {
	#name : 'PackageConflictError',
	#superclass : 'Error',
	#category : 'Kernel-CodeModel-Exceptions',
	#package : 'Kernel-CodeModel',
	#tag : 'Exceptions'
}
