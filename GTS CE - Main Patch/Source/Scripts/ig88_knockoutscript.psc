Scriptname IG88_KnockoutScript extends ReferenceAlias  
{Knocks out the player and advances quest stage}

Event OnTriggerEnter(ObjectReference akActionRef)
	If akActionRef == Game.GetPlayer() && SybilleQuest.getStage() > 0 && SybilleQuest.getStage() < 20 && Game.GetPlayer().HasKeyword(VampireKeyword) == False && PlayerIsWerewolf.GetValue() == 0 && Game.GetPlayer().HasSpell(LichSpell) == 0 && Game.GetPlayer().HasSpell(BearSpell) == 0
		GetOwningQuest().SetStage(10)
	EndIf
EndEvent

Keyword Property VampireKeyword  Auto  

GlobalVariable Property PlayerIsWerewolf  Auto
;CE
Spell Property LichSpell Auto

Spell Property BearSpell Auto

Quest Property SybilleQuest Auto
