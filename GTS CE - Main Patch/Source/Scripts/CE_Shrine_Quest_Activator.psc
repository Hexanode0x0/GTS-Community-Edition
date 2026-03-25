Scriptname CE_Shrine_Quest_Activator extends ObjectReference

CE_Shrine_Quest_Controller Property Shrine_Quest Auto
GlobalVariable Property CE_Deity_Enum Auto
Int Property Deity_Enum Auto
Message Property ChooserBox Auto

Event OnActivate(ObjectReference _)
	if ChooserBox.Show() == 0
		CE_Deity_Enum.setValue(Deity_Enum)
		Shrine_Quest.Stop()
		Shrine_Quest.Reset()
		Shrine_Quest.Start()
		Shrine_Quest.Follow(Deity_Enum)
	endif
EndEvent
