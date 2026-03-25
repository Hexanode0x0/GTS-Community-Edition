Scriptname CE_Shrine_Quest_Listener extends ReferenceAlias

import PO3_Events_Alias

MagicEffect[] Property Shrine_Effects Auto
CE_Shrine_Quest_Controller Property Shrine_Quest Auto
GlobalVariable Property CE_Deity_Enum Auto

Event OnInit()
	UnregisterForAllMagicEffectApplyEx(self)
	RegisterForMagicEffectApplyEx(self, Shrine_Effects[CE_Deity_Enum.GetValue() as int], true)
	;debug.notification("listener registered for " + Shrine_Effects[CE_Deity_Enum.GetValue() as int].GetName())
EndEvent

Event OnMagicEffectApplyEx(ObjectReference _, MagicEffect __, Form ___, Bool ____)
	UnregisterForAllMagicEffectApplyEx(self)
	Shrine_Quest.SetObjectiveCompleted(0)
	Shrine_Quest.CompleteQuest()
	Shrine_Quest.Stop()
EndEvent
