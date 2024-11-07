Class {
	#name : 'EpChangedSettingEvent',
	#superclass : 'EpEvent',
	#instVars : [
		'setting'
	],
	#category : 'Epicea-Model',
	#package : 'Epicea',
	#tag : 'Model'
}

{ #category : 'accessing' }
EpChangedSettingEvent class >> setting: aSettingUpdated [

	^ self new
		setting: aSettingUpdated;
		yourself
]

{ #category : 'accessing' }
EpChangedSettingEvent >> setting [

	^ setting
]

{ #category : 'accessing' }
EpChangedSettingEvent >> setting: anObject [

	setting := anObject
]

{ #category : 'accessing' }
EpChangedSettingEvent >> stonOn: stonWriter [
	"Private - We don't serialize this event since some values are Blocks which are not yet serializable by STON: 
	STONWriterError: custom #stonOn: implementation needed for variable/indexable class."

]
