Scriptname CE_EasyFastTravel Extends ActiveMagicEffect

import PO3_Events_AME

MiscObject Property FastTravelToken Auto
Actor Property PlayerREF Auto

Event OnEffectStart(Actor target, Actor caster)
	RegisterForCellFullyLoaded(self)
	PlayerREF.AddItem(FastTravelToken, 5, true)
EndEvent

Event OnEffectFinish(Actor target, Actor caster)
	UnregisterForCellFullyLoaded(self)
	int count = PlayerREF.GetItemCount(FastTravelToken)
	PlayerREF.RemoveItem(FastTravelToken, count, true)
EndEvent

Event OnCellFullyLoaded(Cell aCell)
	if PlayerREF.GetItemCount(FastTravelToken) < 4
		PlayerREF.AddItem(FastTravelToken, 5, true)
	endif
EndEvent
