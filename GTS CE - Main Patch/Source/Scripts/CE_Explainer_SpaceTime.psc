Scriptname CE_Explainer_SpaceTime Extends ReferenceAlias

import PO3_Events_Alias
import PO3_SKSEFunctions

bool travelSeen = false
bool survivalSeen = false
bool sotwSeen = false
bool jobsSeen = false
bool stormcrownSeen = false
bool dungeonSeen = false
bool experienceSeen = false
bool mineSeen = false
bool remoteSeen = false
bool faceSeen = false
bool missivesSeen = false
bool innSeen = false
bool reputationSeen = false
bool stealthSeen = false
bool blockTutorial = false
bool followersSeen = false

Message[] Property TravelExplainer Auto
Message[] Property SurvivalExplainer Auto
Message[] Property SOTWExplainer Auto
Message[] Property JobsExplainer Auto
Message[] Property StormcrownExplainer Auto
Message[] Property DungeonExplainer Auto
Message[] Property ExperienceExplainer Auto
Message[] Property MineExplainer Auto
Message[] Property RemoteExplainer Auto
Message[] Property FaceSculptorExplainer Auto
Message[] Property MissivesExplainer Auto
Message[] Property InnExplainer Auto
Message[] Property ReputationExplainer Auto
Message[] Property StealthExplainer Auto
Message[] Property TutorialExplainer Auto
Message[] Property FollowersExplainer Auto

GlobalVariable Property CE_BlockExplainers Auto
Actor Property PlayerREF Auto
Quest Property HornOfJurgenWindcaller Auto
Cell Property RaggedFlagon Auto
Perk Property StealthPerk0 Auto

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
	RegisterForQuest(self, HornOfJurgenWindcaller)
	RegisterForCellFullyLoaded(self)
	RegisterForUpdateGameTime(7)
	RegisterForSingleUpdate(3)
EndEvent

Event OnUpdate()
	Utility.Wait(5)
	if PlayerREF.GetCurrentLocation() != DreamOfSovngarde || blockTutorial
		return
	endif
	if CE_BlockExplainers.GetValue() == 1
		RegisterForSingleUpdate(1)
		return
	endif
	int handle = ModEvent.Create("CE_Explainer")
	ModEvent.PushString(handle, " Tutorial")
	ModEvent.Send(handle)
EndEvent

Event OnQuestStart(Quest theQuest)
	;debug.notification("SPACETIME: quest fired")
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
	Location CurrentPlayerLocation = PlayerREF.GetCurrentLocation()
	if CurrentPlayerLocation == DreamOfSovngarde || CE_BlockExplainers.GetValue() == 1
		return
	endif
	Worldspace CurrentPlayerWorldspace = PlayerREF.GetWorldspace()
	bool isExploring = CurrentPlayerWorldspace == Tamriel || CurrentPlayerWorldspace == Solstheim || CurrentPlayerWorldspace == Bruma
	bool isInTown = CurrentPlayerWorldspace == WhiterunWorld || CurrentPlayerWorldspace == WindhelmWorld || CurrentPlayerWorldspace == RiftenWorld || CurrentPlayerWorldspace == MarkarthWorld || CurrentPlayerWorldspace == SolitudeWorld || CurrentPlayerLocation == MorthalLocation || CurrentPlayerLocation == FalkreathLocation || CurrentPlayerLocation == DawnstarLocation || CurrentPlayerLocation == WinterholdLocation
	Actor[] followers = GetPlayerFollowers()

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

Event OnExplainerCallback(string name, bool accepted)
	if !accepted
		if name == " Tutorial"
			RegisterForSingleUpdate(1)
		endif
		return
	endif

	if name == "Finding Your Way"
		ShowExplainer(TravelExplainer)
	elseif name == "Survival Mode"
		ShowExplainer(SurvivalExplainer)
	elseif name == "Skills of the Wild"
		ShowExplainer(SOTWExplainer)
	elseif name == "City Jobs"
		ShowExplainer(JobsExplainer)
	elseif name == "Thu'um Perks"
		ShowExplainer(StormcrownExplainer)
	elseif name == "Dungeon Levels"
		ShowExplainer(DungeonExplainer)
	elseif name == "Experience and Levels"
		ShowExplainer(ExperienceExplainer)
	elseif name == "About Mining"
		ShowExplainer(MineExplainer)
	elseif name == "Remote Interactions"
		ShowExplainer(RemoteExplainer)
	elseif name == "Face Sculptor"
		ShowExplainer(FaceSculptorExplainer)
	elseif name == "Missives Board"
		ShowExplainer(MissivesExplainer)
	elseif name == "Inns and Carriages"
		ShowExplainer(InnExplainer)
	elseif name == "Reputation"
		ShowExplainer(ReputationExplainer)
	elseif name == "Stealth"
		ShowExplainer(StealthExplainer)
	elseif name == " Tutorial"
		ShowTutorialExplainer(TutorialExplainer)
		RegisterForSingleUpdate(1)
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

Function ShowTutorialExplainer(Message[] daBook)
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
		elseif selected == 3
		    blockTutorial = true
			return
		endif

	endWhile
EndFunction
