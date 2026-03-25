Scriptname CE_Shrine_Quest_Controller extends Quest

ObjectReference Property Marker0 Auto
ObjectReference Property Marker1 Auto
ObjectReference Property Marker2 Auto

;Deity Enum
;0
ObjectReference Property Shrine_Akatosh0 Auto
ObjectReference Property Shrine_Akatosh1 Auto
ObjectReference Property Shrine_Akatosh2 Auto
;1
ObjectReference Property Shrine_Arkay0 Auto
ObjectReference Property Shrine_Arkay1 Auto
ObjectReference Property Shrine_Arkay2 Auto
;2
ObjectReference Property Shrine_Dibella0 Auto
ObjectReference Property Shrine_Dibella1 Auto
ObjectReference Property Shrine_Dibella2 Auto
;3
ObjectReference Property Shrine_Julianos0 Auto
ObjectReference Property Shrine_Julianos1 Auto
ObjectReference Property Shrine_Julianos2 Auto
;4
ObjectReference Property Shrine_Kynareth0 Auto
ObjectReference Property Shrine_Kynareth1 Auto
ObjectReference Property Shrine_Kynareth2 Auto
;5
ObjectReference Property Shrine_Mara0 Auto
ObjectReference Property Shrine_Mara1 Auto
ObjectReference Property Shrine_Mara2 Auto
;6
ObjectReference Property Shrine_Stendarr0 Auto
ObjectReference Property Shrine_Stendarr1 Auto
ObjectReference Property Shrine_Stendarr2 Auto
;7
ObjectReference Property Shrine_Talos0 Auto
ObjectReference Property Shrine_Talos1 Auto
ObjectReference Property Shrine_Talos2 Auto
;8
ObjectReference Property Shrine_Zenithar0 Auto
ObjectReference Property Shrine_Zenithar1 Auto
ObjectReference Property Shrine_Zenithar2 Auto
;9
ObjectReference Property Shrine_Hircine0 Auto
ObjectReference Property Shrine_Hircine1 Auto
;10
ObjectReference Property Shrine_Hermaeus_Mora0 Auto
;11
ObjectReference Property Shrine_Azura0 Auto
ObjectReference Property Shrine_Azura1 Auto
ObjectReference Property Shrine_Azura2 Auto
;12
ObjectReference Property Shrine_Malacath0 Auto
ObjectReference Property Shrine_Malacath1 Auto
ObjectReference Property Shrine_Malacath2 Auto
;13
ObjectReference Property Shrine_Mehrunes_Dagon0 Auto
;14
ObjectReference Property Shrine_Meridia0 Auto
;15
ObjectReference Property Shrine_Peryite0 Auto
;16
ObjectReference Property Shrine_Sheogorath0 Auto
;17
ObjectReference Property Shrine_Jephre0 Auto
ObjectReference Property Shrine_Jephre1 Auto
;18
ObjectReference Property Shrine_Phynaster0 Auto
ObjectReference Property Shrine_Phynaster1 Auto
;19
ObjectReference Property Shrine_Syrabane0 Auto
ObjectReference Property Shrine_Syrabane1 Auto
;20
ObjectReference Property Shrine_HoonDing0 Auto
ObjectReference Property Shrine_HoonDing1 Auto
;21
ObjectReference Property Shrine_Tall_Papa0 Auto
ObjectReference Property Shrine_Tall_Papa1 Auto
;22
ObjectReference Property Shrine_Yffre0 Auto
ObjectReference Property Shrine_Yffre1 Auto
ObjectReference Property Shrine_Yffre2 Auto
;23
ObjectReference Property Shrine_Auriel0 Auto
;24
ObjectReference Property Shrine_Mephala0 Auto
ObjectReference Property Shrine_Mephala1 Auto
ObjectReference Property Shrine_Mephala2 Auto
;25
ObjectReference Property Shrine_Clavicus_Vile0 Auto
;26
ObjectReference Property Shrine_Molag_Bal0 Auto
;27
ObjectReference Property Shrine_Namira0 Auto
;28
ObjectReference Property Shrine_Sanguine0 Auto
ObjectReference Property Shrine_Sanguine1 Auto
;29
ObjectReference Property Shrine_Boethiah0 Auto
ObjectReference Property Shrine_Boethiah1 Auto
ObjectReference Property Shrine_Boethiah2 Auto
;30
ObjectReference Property Shrine_Hist0 Auto
ObjectReference Property Shrine_Hist1 Auto
ObjectReference Property Shrine_Hist2 Auto

Function Follow(int Deity_Enum)
	;debug.notification("running follow enum is " + Deity_Enum as String)
	Marker0.MoveToMyEditorLocation()
	Marker1.MoveToMyEditorLocation()
	Marker2.MoveToMyEditorLocation()
	if Deity_Enum == 0
		Marker0.moveto(Shrine_Akatosh0)
		Marker1.moveto(Shrine_Akatosh1)
		Marker2.moveto(Shrine_Akatosh2)
	elseif Deity_Enum == 1
		Marker0.moveto(Shrine_Arkay0)
		Marker1.moveto(Shrine_Arkay1)
		Marker2.moveto(Shrine_Arkay2)
	elseif Deity_Enum == 2
		Marker0.moveto(Shrine_Dibella0)
		Marker1.moveto(Shrine_Dibella1)
		Marker2.moveto(Shrine_Dibella2)
	elseif Deity_Enum == 3
		Marker0.moveto(Shrine_Julianos0)
		Marker1.moveto(Shrine_Julianos1)
		Marker2.moveto(Shrine_Julianos2)
	elseif Deity_Enum == 4
		Marker0.moveto(Shrine_Kynareth0)
		Marker1.moveto(Shrine_Kynareth1)
		Marker2.moveto(Shrine_Kynareth2)
	elseif Deity_Enum == 5
		Marker0.moveto(Shrine_Mara0)
		Marker1.moveto(Shrine_Mara1)
		Marker2.moveto(Shrine_Mara2)
	elseif Deity_Enum == 6
		Marker0.moveto(Shrine_Stendarr0)
		Marker1.moveto(Shrine_Stendarr1)
		Marker2.moveto(Shrine_Stendarr2)
	elseif Deity_Enum == 7
		Marker0.moveto(Shrine_Talos0)
		Marker1.moveto(Shrine_Talos1)
		Marker2.moveto(Shrine_Talos2)
	elseif Deity_Enum == 8
		Marker0.moveto(Shrine_Zenithar0)
		Marker1.moveto(Shrine_Zenithar1)
		Marker2.moveto(Shrine_Zenithar2)
	elseif Deity_Enum == 9
		Marker0.moveto(Shrine_Hircine0)
		Marker1.moveto(Shrine_Hircine1)
	elseif Deity_Enum == 10
		Marker0.moveto(Shrine_Hermaeus_Mora0)
	elseif Deity_Enum == 11
		Marker0.moveto(Shrine_Azura0)
		Marker1.moveto(Shrine_Azura1)
		Marker2.moveto(Shrine_Azura2)
	elseif Deity_Enum == 12
		Marker0.moveto(Shrine_Malacath0)
		Marker1.moveto(Shrine_Malacath1)
		Marker2.moveto(Shrine_Malacath2)
	elseif Deity_Enum == 13
		Marker0.moveto(Shrine_Mehrunes_Dagon0)
	elseif Deity_Enum == 14
		Marker0.moveto(Shrine_Meridia0)
	elseif Deity_Enum == 15
		Marker0.moveto(Shrine_Peryite0)
	elseif Deity_Enum == 16
		Marker0.moveto(Shrine_Sheogorath0)
	elseif Deity_Enum == 17
		Marker0.moveto(Shrine_Jephre0)
		Marker1.moveto(Shrine_Jephre1)
	elseif Deity_Enum == 18
		Marker0.moveto(Shrine_Phynaster0)
		Marker1.moveto(Shrine_Phynaster1)
	elseif Deity_Enum == 19
		Marker0.moveto(Shrine_Syrabane0)
		Marker1.moveto(Shrine_Syrabane1)
	elseif Deity_Enum == 20
		Marker0.moveto(Shrine_HoonDing0)
		Marker1.moveto(Shrine_HoonDing1)
	elseif Deity_Enum == 21
		Marker0.moveto(Shrine_Tall_Papa0)
		Marker1.moveto(Shrine_Tall_Papa1)
	elseif Deity_Enum == 22
		Marker0.moveto(Shrine_Yffre0)
		Marker1.moveto(Shrine_Yffre1)
		Marker2.moveto(Shrine_Yffre2)
	elseif Deity_Enum == 23
		Marker0.moveto(Shrine_Auriel0)
	elseif Deity_Enum == 24
		Marker0.moveto(Shrine_Mephala0)
		Marker1.moveto(Shrine_Mephala1)
		Marker2.moveto(Shrine_Mephala2)
	elseif Deity_Enum == 25
		Marker0.moveto(Shrine_Clavicus_Vile0)
	elseif Deity_Enum == 26
		Marker0.moveto(Shrine_Molag_Bal0)
	elseif Deity_Enum == 27
		Marker0.moveto(Shrine_Namira0)
	elseif Deity_Enum == 28
		Marker0.moveto(Shrine_Sanguine0)
		Marker1.moveto(Shrine_Sanguine1)
	elseif Deity_Enum == 29
		Marker0.moveto(Shrine_Boethiah0)
		Marker1.moveto(Shrine_Boethiah1)
		Marker2.moveto(Shrine_Boethiah2)
	elseif Deity_Enum == 30
		Marker0.moveto(Shrine_Hist0)
		Marker1.moveto(Shrine_Hist1)
		Marker2.moveto(Shrine_Hist2)
	else
		Debug.notification("Invalid deity")
	endif
	self.SetObjectiveDisplayed(0)
endFunction
