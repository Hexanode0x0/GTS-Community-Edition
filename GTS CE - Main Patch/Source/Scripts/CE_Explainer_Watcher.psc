Scriptname CE_Explainer_Watcher Extends ReferenceAlias

import PO3_Events_Alias

Event OnPlayerLoadGame()
    UnRegisterForModEvent("CE_Explainer_Callback")
	UnRegisterForModEvent("CE_Spell_Learned")
	UnRegisterForItemCrafted(self)
	UnRegisterForAllQuests(self)
	UnRegisterForCellFullyLoaded(self)
	UnRegisterForActorKilled(self)
	UnRegisterForTrackedStatsEvent()
	UnRegisterForUpdateGameTime()
	UnRegisterForUpdate()
EndEvent

Event OnInit()
	UnRegisterForModEvent("CE_Explainer_Callback")
	UnRegisterForModEvent("CE_Spell_Learned")
	UnRegisterForItemCrafted(self)
	UnRegisterForAllQuests(self)
	UnRegisterForCellFullyLoaded(self)
	UnRegisterForActorKilled(self)
	UnRegisterForTrackedStatsEvent()
	UnRegisterForUpdateGameTime()
	UnRegisterForUpdate()
EndEvent
