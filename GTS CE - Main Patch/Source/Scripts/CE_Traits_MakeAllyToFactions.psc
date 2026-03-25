Scriptname CE_Traits_MakeAllyToFactions extends activemagiceffect

FormList Property FactionsList Auto
Faction Property PlayerFaction Auto

Event OnEffectStart(Actor akTarget, Actor _)
	RegisterForAnimationEvent(Game.GetPlayer(), "tailHorseMount")
    Int i = FactionsList.GetSize()
    While i != 0
        i -= 1
        akTarget.AddToFaction(FactionsList.GetAt(i) as Faction)
        PlayerFaction.SetReaction(FactionsList.GetAt(i) as Faction, 3)
    EndWhile
EndEvent

Event OnEffectFinish(Actor akTarget, Actor _)
    Int i = FactionsList.GetSize()
    While i != 0
        i -= 1
        akTarget.RemoveFromFaction(FactionsList.GetAt(i) as Faction)
        PlayerFaction.SetReaction(FactionsList.GetAt(i) as Faction, 1)
    EndWhile
EndEvent

Event OnAnimationEvent (ObjectReference akSource, string asEventName)
	If akSource == Game.GetPlayer() && asEventName == "tailHorseMount"
		Actor Playerhorse =	Game.GetPlayersLastRiddenHorse()
		if Playerhorse == none
			return
		endif
		Int i = FactionsList.GetSize()
		While i != 0
			i -= 1
			Playerhorse.AddToFaction(FactionsList.GetAt(i) as Faction)
		EndWhile
	endif
EndEvent
