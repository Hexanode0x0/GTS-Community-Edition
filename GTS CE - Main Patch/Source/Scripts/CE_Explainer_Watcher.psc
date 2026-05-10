Scriptname CE_Explainer_Watcher Extends ReferenceAlias

import PO3_Events_Alias
import PO3_SKSEFunctions

bool bleesingsSeen = false
bool travelSeen = false
bool survivalSeen = false
bool sotwSeen = false
bool bardSeen = false
bool forgeBookSeen = false
bool degradationSeen = false
bool jobsSeen = false
bool stormcrownSeen = false
bool dungeonSeen = false
bool huntingSeen = false
bool woundsSeen = false
bool experienceSeen = false
bool combatSeen = false
bool resistanceSeen = false
bool mineSeen = false
bool dirtySeen = false
bool horseSeen = false
bool followersSeen = false
bool remoteSeen = false
bool stressSeen = false
bool fearSeen = false
bool vampirismSeen = false
bool werewolfSeen = false
bool faceSeen = false
bool missivesSeen = false
bool hackingSeen = false
bool spellLearnSeen = false
bool innSeen = false
bool reputationSeen = false
bool stealthSeen = false

Message[] Property BlessingExplainer Auto
Message[] Property TravelExplainer Auto
Message[] Property SurvivalExplainer Auto
Message[] Property SOTWExplainer Auto
Message[] Property BardExplainer Auto
Message[] Property ForgeBookExplainer Auto
Message[] Property DegradationExplainer Auto
Message[] Property JobsExplainer Auto
Message[] Property StormcrownExplainer Auto
Message[] Property DungeonExplainer Auto
Message[] Property HuntingExplainer Auto
Message[] Property WoundsExplainer Auto
Message[] Property ExperienceExplainer Auto
Message[] Property CombatExplainer Auto
Message[] Property ResistanceExplainer Auto
Message[] Property MineExplainer Auto
Message[] Property DirtyExplainer Auto
Message[] Property HorseExplainer Auto
Message[] Property FollowersExplainer Auto
Message[] Property RemoteExplainer Auto
Message[] Property StressExplainer Auto
Message[] Property FearExplainer Auto
Message[] Property VampirismExplainer Auto
Message[] Property WerewolfExplainer Auto
Message[] Property FaceSculptorExplainer Auto
Message[] Property MissivesExplainer Auto
Message[] Property HackingExplainer Auto
Message[] Property SpellLearnExplainer Auto
Message[] Property InnExplainer Auto
Message[] Property ReputationExplainer Auto
Message[] Property StealthExplainer Auto
Message[] Property TutorialExplainer Auto

Formlist Property KeywordsToWatch Auto
GlobalVariable Property CE_BlockExplainers Auto
GlobalVariable Property HasUnlockedHacking Auto
Actor Property PlayerREF Auto
Quest Property HornOfJurgenWindcaller Auto
Quest Property ExplainerQuest Auto
Cell Property RaggedFlagon Auto
Spell Property TraitDwemerResearcher Auto
Perk Property StealthPerk0 Auto

Faction Property PreyFaction Auto
Faction Property STPreyFaction Auto
Faction Property STPredatorFaction Auto

Keyword Property ActorTypeDwarven Auto
Keyword Property CrafterGrindstone Auto
Keyword Property CrafterWorkbench Auto
Keyword Property CrafterForge Auto
Keyword Property LocTypeDungeon Auto
Keyword Property LocTypeMine Auto
Keyword Property LocTypeInn Auto

Worldspace Property Tamriel Auto
Worldspace Property Solstheim Auto
Worldspace Property Bruma Auto
Worldspace Property WhiterunWorld Auto
Worldspace Property WindhelmWorld Auto
Worldspace Property SolitudeWorld Auto
Worldspace Property RiftenWorld Auto
Worldspace Property MarkarthWorld Auto

Location Property DreamOfSovngarde Auto
Location Property MorthalLocation Auto
Location Property FalkreathLocation Auto
Location Property DawnstarLocation Auto
Location Property WinterholdLocation Auto

Event OnInit()
	RegisterForModEvent("CE_Explainer_Callback", "OnExplainerCallback")
	RegisterForMagicEffectApplyEx(self, KeywordsToWatch, true)
	RegisterForItemCrafted(self)
	RegisterForQuest(self, HornOfJurgenWindcaller)
	RegisterForCellFullyLoaded(self)
	RegisterForActorKilled(self)
	RegisterForAnimationEvent(PlayerREF, "tailHorseMount")
	RegisterForSpellLearned(self)
	RegisterForUpdateGameTime(14)
	RegisterForSingleUpdate(1)
EndEvent

Event OnPlayerLoadGame()
	(ExplainerQuest as CE_Explainer_Controller).GenerateClientID()
EndEvent

Event OnUpdate()
	if CE_BlockExplainers.GetValue() == 1 || PlayerREF.GetCurrentLocation() != DreamOfSovngarde
		return
	endif
	Utility.Wait(5)
	int handle = ModEvent.Create("CE_Explainer")
	ModEvent.PushString(handle, " Tutorial")
	ModEvent.Send(handle)
EndEvent

Event OnMagicEffectApplyEx(ObjectReference caster, MagicEffect effect, Form source, bool applied)
	debug.notification("magic apply fired")
	if CE_BlockExplainers.GetValue() == 1
		return
	endif
	
	if !bleesingsSeen && (effect.hasKeyword(KeywordsToWatch.getAt(0) as Keyword) || effect.hasKeyword(keywordsToWatch.getAt(1) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "About Blessings")
		bleesingsSeen = true
		Utility.Wait(10)
		ModEvent.Send(handle)
	elseif !bardSeen && (effect.hasKeyword(KeywordsToWatch.getAt(2) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Playing Music")
		bardSeen = true
		Utility.Wait(10)
		ModEvent.Send(handle)
	elseif !woundsSeen && (effect.hasKeyword(KeywordsToWatch.getAt(3) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Injuries and Wounds")
		ModEvent.Send(handle)
		woundsSeen = true
	elseif !dirtySeen && (effect.hasKeyword(KeywordsToWatch.getAt(4) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Dirt and Blood")
		ModEvent.Send(handle)
		dirtySeen = true
	elseif !stressSeen && (effect.hasKeyword(KeywordsToWatch.getAt(5) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Combat Stress")
		ModEvent.Send(handle)
		stressSeen = true
	elseif !fearSeen && (effect.hasKeyword(KeywordsToWatch.getAt(6) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "About Fear")
		ModEvent.Send(handle)
		fearSeen = true
	endif
	
	if fearSeen && stressSeen && dirtySeen && woundsSeen && bardSeen && bleesingsSeen
		UnregisterForAllMagicEffectApplyEx(self)
	endif
EndEvent

Event OnItemCrafted(ObjectReference crafter, Location craftingLocation, Form craftedItem)
	debug.notification("item crafted fired")
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

Event OnQuestStart(Quest theQuest)
	debug.notification("quest fired")
	if CE_BlockExplainers.GetValue() == 1
		return
	endif

	if !stormcrownSeen && theQuest == HornOfJurgenWindcaller
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Thu'um Perks")
		ModEvent.Send(handle)
		stormcrownSeen = true
	endif
	
	if stormcrownSeen
		UnregisterForAllQuests(self)
	endif
EndEvent

Event OnUpdateGameTime()
	debug.notification("GameTime Fired")
	Location CurrentPlayerLocation = PlayerREF.GetCurrentLocation()
	if CurrentPlayerLocation == DreamOfSovngarde || CE_BlockExplainers.GetValue() == 1
		return
	endif
	Worldspace CurrentPlayerWorldspace = PlayerREF.GetWorldspace()
	bool isExploring = CurrentPlayerWorldspace == Tamriel || CurrentPlayerWorldspace == Solstheim || CurrentPlayerWorldspace == Bruma
	bool isInTown = CurrentPlayerWorldspace == WhiterunWorld || CurrentPlayerWorldspace == WindhelmWorld || CurrentPlayerWorldspace == RiftenWorld || CurrentPlayerWorldspace == MarkarthWorld || CurrentPlayerWorldspace == SolitudeWorld || CurrentPlayerLocation == MorthalLocation || CurrentPlayerLocation == FalkreathLocation || CurrentPlayerLocation == DawnstarLocation || CurrentPlayerLocation == WinterholdLocation
	Actor[] followers = GetPlayerFollowers()
	if isExploring
		debug.notification("Is exploring")
	endif
	if isInTown
		debug.notification("Is town")
	endif
	
	if !travelSeen && isExploring
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Finding Your Way")
		ModEvent.Send(handle)
		travelSeen = true
	elseif !survivalSeen
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Survival Mode")
		ModEvent.Send(handle)
		survivalSeen = true
	elseif !sotwSeen && isExploring
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Skills of the Wild")
		ModEvent.Send(handle)
		sotwSeen = true
	elseif !jobsSeen && isInTown
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "City Jobs")
		ModEvent.Send(handle)
		jobsSeen = true
	elseif !missivesSeen && isInTown
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Missives Board")
		ModEvent.Send(handle)
		missivesSeen = true
	elseif !experienceSeen
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Experience and Levels")
		ModEvent.Send(handle)
		experienceSeen = true
	elseif !followersSeen && followers[0] != None
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Followers")
		ModEvent.Send(handle)
		followersSeen = true
	elseif !remoteSeen && isInTown
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Remote Interactions")
		ModEvent.Send(handle)
		remoteSeen = true
	elseif !reputationSeen
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Reputation")
		ModEvent.Send(handle)
		reputationSeen = true
	endif
	
	if travelSeen && survivalSeen && sotwSeen && jobsSeen && missivesSeen && experienceSeen && followersSeen && remoteSeen && reputationSeen
		UnregisterForUpdateGameTime()
	endif
EndEvent

Event OnCellFullyLoaded(Cell loadedCell)
	debug.notification("cell load fired")
	if !PlayerREF.IsInInterior() || CE_BlockExplainers.GetValue() == 1
		return
	endif
	
	if !dungeonSeen && PlayerREF.GetCurrentLocation().HasKeyword(LocTypeDungeon) && Game.QueryStat("Dungeons Cleared") > 4
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Dungeon Levels")
		dungeonSeen = true
		Utility.Wait(5)
		ModEvent.Send(handle)
	elseif !mineSeen && PlayerREF.GetCurrentLocation().HasKeyword(LocTypeMine)
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "About Mining")
		mineSeen = true
		Utility.Wait(5)
		ModEvent.Send(handle)
	elseif !innSeen && PlayerREF.GetCurrentLocation().HasKeyword(LocTypeInn) && Game.QueryStat("Days Passed") > 2
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Inns and Carriages")
		innSeen = true
		Utility.Wait(5)
		ModEvent.Send(handle)
	elseif !faceSeen && loadedCell == RaggedFlagon
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Face Sculptor")
		faceSeen = true
		Utility.Wait(10)
		ModEvent.Send(handle)
	elseif !stealthSeen && PlayerREF.HasPerk(StealthPerk0) && PlayerREF.GetCurrentLocation().HasKeyword(LocTypeDungeon)
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Stealth")
		stealthSeen = true
		Utility.Wait(10)
		ModEvent.Send(handle)
	endif
	
	if dungeonSeen && mineSeen && innSeen && faceSeen && stealthSeen
		UnregisterForCellFullyLoaded(self)
	endif
EndEvent

Event OnActorKilled(Actor victim, Actor killer)
	debug.notification("actor kill fired")
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
	endif
	
	if huntingSeen && combatSeen && resistanceSeen && hackingSeen
		UnregisterForActorKilled(self)
	endif
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	debug.notification("animation event fired")
	if akSource != PlayerREF || CE_BlockExplainers.GetValue() == 1
		return
	endif
	
	if !horseSeen && asEventName == "tailHorseMount"
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Horses")
		ModEvent.Send(handle)
		horseSeen = true
	endif
	
	if horseSeen
		UnregisterForAnimationEvent(PlayerREF, "tailHorseMount")
	endif
EndEvent

Event OnVampirismStateChanged(bool isVampire)
	debug.notification("vampire fired")
	if !isVampire || CE_BlockExplainers.GetValue() == 1
		return
	endif
	
	if !vampirismSeen
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Vampirism")
		vampirismSeen = true
		Utility.Wait(10)
		ModEvent.Send(handle)
	endif
EndEvent

Event OnLycanthropyStateChanged(bool isWerewolf)
	debug.notification("werewolf fired")
	if !isWerewolf || CE_BlockExplainers.GetValue() == 1
		return
	endif
	
	if !werewolfSeen
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Lycanthropy")
		werewolfSeen = true
		Utility.Wait(10)
		ModEvent.Send(handle)
	endif
EndEvent

Event OnSpellLearned(Spell learnedSpell)
	debug.notification("spell Learned fired")
	if CE_BlockExplainers.GetValue() == 1
		return
	endif
	
	if !spellLearnSeen && Game.QueryStat("Spells Learned") >= 10
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Learning Spells")
		ModEvent.Send(handle)
		spellLearnSeen = true
	endif
	
	if spellLearnSeen
		UnregisterForSpellLearned(self)
	endif
EndEvent

Event OnExplainerCallback(string name, bool accepted)
	if !accepted
		if name == " Tutorial"
			RegisterForSingleUpdate(1)
		endif
		return
	endif

	if name == "About Blessings"
		ShowExplainer(BlessingExplainer)
	elseif name == "Finding Your Way"
		ShowExplainer(TravelExplainer)
	elseif name == "Survival Mode"
		ShowExplainer(SurvivalExplainer)
	elseif name == "Skills of the Wild"
		ShowExplainer(SOTWExplainer)
	elseif name == "Playing Music"
		ShowExplainer(BardExplainer)
	elseif name == "Forge Recipes"
		ShowExplainer(ForgeBookExplainer)
	elseif name == "Gear Degradation"
		ShowExplainer(DegradationExplainer)
	elseif name == "City Jobs"
		ShowExplainer(JobsExplainer)
	elseif name == "Thu'um Perks"
		ShowExplainer(StormcrownExplainer)
	elseif name == "Dungeon Levels"
		ShowExplainer(DungeonExplainer)
	elseif name == "About Hunting"
		ShowExplainer(HuntingExplainer)
	elseif name == "Injuries and Wounds"
		ShowExplainer(WoundsExplainer)
	elseif name == "Experience and Levels"
		ShowExplainer(ExperienceExplainer)
	elseif name == "About Combat"
		ShowExplainer(CombatExplainer)
	elseif name == "Armor and Resistance"
		ShowExplainer(ResistanceExplainer)
	elseif name == "About Mining"
		ShowExplainer(MineExplainer)
	elseif name == "Dirt and Blood"
		ShowExplainer(DirtyExplainer)
	elseif name == "Followers"
		ShowExplainer(FollowersExplainer)
	elseif name == "Remote Interactions"
		ShowExplainer(RemoteExplainer)
	elseif name == "Combat Stress"
		ShowExplainer(StressExplainer)
	elseif name == "About Fear"
		ShowExplainer(FearExplainer)
	elseif name == "Vampirism"
		ShowExplainer(VampirismExplainer)
	elseif name == "Lycanthropy"
		ShowExplainer(WerewolfExplainer)
	elseif name == "Face Sculptor"
		ShowExplainer(FaceSculptorExplainer)
	elseif name == "Missives Board"
		ShowExplainer(MissivesExplainer)
	elseif name == "Hacking Automatons"
		ShowExplainer(HackingExplainer)
	elseif name == "Learning Spells"
		ShowExplainer(SpellLearnExplainer)
	elseif name == "Inns and Carriages"
		ShowExplainer(InnExplainer)
	elseif name == "Reputation"
		ShowExplainer(ReputationExplainer)
	elseif name == "Stealth"
		ShowExplainer(StealthExplainer)
	elseif name == " Tutorial"
		ShowExplainer(TutorialExplainer)
		RegisterForSingleUpdate(1)
	endif
	
EndEvent

Function ShowExplainer(Message[] daBook)
	bool exit = false
	int currentPage = 0
	while !exit
		int selected = daBook[currentPage].Show()
		if selected == 0
			currentPage = currentPage - 1
		elseif selected == 1
			exit = true
		elseif selected == 2
			currentPage = currentPage + 1
		endif
	endWhile
EndFunction
