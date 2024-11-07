Class {
	#name : 'EpCangedSettingEvent',
	#superclass : 'EpEvent',
	#instVars : [
		'setting'
	],
	#category : 'Epicea-Model',
	#package : 'Epicea',
	#tag : 'Model'
}

{ #category : 'accessing' }
EpCangedSettingEvent class >> setting: aSettingUpdated [

	^ self new
		setting: aSettingUpdated;
		yourself
]

{ #category : 'accessing' }
EpCangedSettingEvent >> setting [

	^ setting
]

{ #category : 'accessing' }
EpCangedSettingEvent >> setting: anObject [

	setting := anObject
]

{ #category : 'accessing' }
EpCangedSettingEvent >> stonOn: stonWriter [
	"Private - We don't serialize this event since some values are Blocks which are not yet serializable by STON: 
	STONWriterError: custom #stonOn: implementation needed for variable/indexable class."

]
