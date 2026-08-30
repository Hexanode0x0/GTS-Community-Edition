Scriptname CE_Explainer_CombatCraft Extends ReferenceAlias

import PO3_Events_Alias

bool forgeBookSeen = false
bool degradationSeen = false
bool huntingSeen = false
bool combatSeen = false
bool resistanceSeen = false
bool hackingSeen = false
bool spellLearnSeen = false
bool stressSeen = false
bool dirtySeen = false

Message[] Property ForgeBookExplainer Auto
Message[] Property DegradationExplainer Auto
Message[] Property HuntingExplainer Auto
Message[] Property CombatExplainer Auto
Message[] Property ResistanceExplainer Auto
Message[] Property DirtyExplainer Auto
Message[] Property StressExplainer Auto
Message[] Property HackingExplainer Auto

GlobalVariable Property CE_BlockExplainers Auto
GlobalVariable Property HasUnlockedHacking Auto
GlobalVariable Property Stress_Total Auto
Actor Property PlayerREF Auto
Spell Property TraitDwemerResearcher Auto
MagicEffect Property Dirty_Effect_Dirt3 Auto
MagicEffect Property Dirty_Effect_Blood3 Auto

Faction Property PreyFaction Auto
Faction Property STPreyFaction Auto
Faction Property STPredatorFaction Auto

Keyword Property ActorTypeDwarven Auto
Keyword Property CrafterGrindstone Auto
Keyword Property CrafterWorkbench Auto
Keyword Property CrafterForge Auto

Event OnInit()
	RegisterForModEvent("CE_Explainer_Callback", "OnExplainerCallback")
	RegisterForItemCrafted(self)
	RegisterForActorKilled(self)
EndEvent

Event OnItemCrafted(ObjectReference crafter, Location craftingLocation, Form craftedItem)
	if CE_BlockExplainers.GetValue() == 1
		return
	endif

	if !forgeBookSeen && crafter.HasKeyword(CrafterForge)
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Forge Recipes")
		ModEvent.Send(handle)
		forgeBookSeen = true
	elseif !degradationSeen && (crafter.HasKeyword(CrafterGrindstone) || crafter.HasKeyword(CrafterWorkbench))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Gear Degradation")
		ModEvent.Send(handle)
		degradationSeen = true
	endif

	if forgeBookSeen && degradationSeen
		UnregisterForItemCrafted(self)
	endif
EndEvent

Event OnActorKilled(Actor victim, Actor killer)
	if !killer == PlayerREF || CE_BlockExplainers.GetValue() == 1
		return
	endif

	if !huntingSeen && Game.QueryStat("Animals Killed") > 10 && (victim.IsInFaction(STPreyFaction) || victim.IsInFaction(PreyFaction) || victim.IsInFaction(STPredatorFaction))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "About Hunting")
		ModEvent.Send(handle)
		huntingSeen = true
	elseif !combatSeen && Game.QueryStat("People Killed") > 20
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "About Combat")
		ModEvent.Send(handle)
		combatSeen = true
	elseif !resistanceSeen && Game.QueryStat("People Killed") > 40
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Armor and Resistance")
		ModEvent.Send(handle)
		resistanceSeen = true
	elseif !hackingSeen && victim.HasKeyword(ActorTypeDwarven) && ((game.QueryStat("Automatons Killed") > 20 && PlayerREF.GetActorValue("Sneak") >= 40) || HasUnlockedHacking.GetValue() == 1 || PlayerREF.HasSpell(TraitDwemerResearcher))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Hacking Automatons")
		ModEvent.Send(handle)
		hackingSeen = true
	elseif !dirtySeen && (PlayerREF.HasMagicEffect(Dirty_Effect_Blood3) || PlayerREF.HasMagicEffect(Dirty_Effect_Dirt3))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Dirt and Blood")
		ModEvent.Send(handle)
		dirtySeen = true
	elseif !stressSeen && Stress_Total.GetValue() > 45
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Combat Stress")
		ModEvent.Send(handle)
		stressSeen = true
	endif

	if huntingSeen && combatSeen && resistanceSeen && hackingSeen && dirtySeen && stressSeen
		UnregisterForActorKilled(self)
	endif
EndEvent

Event OnExplainerCallback(string name, bool accepted)
	if !accepted
		return
	endif

	if name == "Forge Recipes"
		ShowExplainer(ForgeBookExplainer)
	elseif name == "Gear Degradation"
		ShowExplainer(DegradationExplainer)
	elseif name == "About Hunting"
		ShowExplainer(HuntingExplainer)
	elseif name == "About Combat"
		ShowExplainer(CombatExplainer)
	elseif name == "Armor and Resistance"
		ShowExplainer(ResistanceExplainer)
	elseif name == "Dirt and Blood"
		ShowExplainer(DirtyExplainer)
	elseif name == "Combat Stress"
		ShowExplainer(StressExplainer)
	elseif name == "Hacking Automatons"
		ShowExplainer(HackingExplainer)
	endif

EndEvent

Function ShowExplainer(Message[] daBook)
	int currentPage = 0
	while true
	    if currentPage <= -1 || currentPage + 1 > daBook.length
			return
		endif

		int selected = daBook[currentPage].Show()
		if selected == 0
			currentPage = currentPage - 1
		elseif selected == 1
		    return
		elseif selected == 2
			currentPage = currentPage + 1
		endif

	endWhile
EndFunction
