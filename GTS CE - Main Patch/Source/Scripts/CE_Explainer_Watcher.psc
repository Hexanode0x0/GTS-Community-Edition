Scriptname CE_Explainer_Watcher extends ReferenceAlias

import PO3_Events_Alias

bool bleesingsSeen = false
bool travelSeen = false
bool survivalSeen = false
bool sotwSeen = false

Message[] Property BlessingExplainer Auto
Message[] Property TravelExplainer Auto
Message[] Property SurvivalExplainer Auto
Message[] Property SOTWExplainer Auto

Formlist Property keywordsToWatch Auto
GlobalVariable Property CE_BlockExplainers Auto
Location Property DreamOfSovngarde Auto
Actor Property PlayerREF Auto
Worldspace Property Tamriel Auto
Worldspace Property Solstheim Auto
Worldspace Property Bruma Auto

Event OnInit()
	RegisterForMagicEffectApplyEx(self, keywordsToWatch, true)
	RegisterForModEvent("CE_Explainer_Callback", "OnExplainerCallback")
	RegisterForUpdateGameTime(14)
EndEvent

Event OnMagicEffectApplyEx(ObjectReference caster, MagicEffect effect, Form source, bool applied)
	if CE_BlockExplainers.getValue() == 1
		return
	endif
	
	if !bleesingsSeen && (effect.hasKeyword(keywordsToWatch.getAt(0) as Keyword) || effect.hasKeyword(keywordsToWatch.getAt(1) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "About Blessings")
		utility.wait(10)
		ModEvent.Send(handle)
	endif
EndEvent

Event OnUpdateGameTime()
	Location CurrentPlayerLocation = PlayerREF.GetCurrentLocation()
	Worldspace CurrentPlayerWorldspace = PlayerREF.GetWorldspace()
	if CurrentPlayerLocation == DreamOfSovngarde || CE_BlockExplainers.getValue() == 1
		return
	elseif !travelSeen && !PlayerREF.IsInInterior() && (CurrentPlayerWorldspace == Tamriel || CurrentPlayerWorldspace == Solstheim || CurrentPlayerWorldspace == Bruma)
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Finding Your Way")
		ModEvent.Send(handle)
	elseif !survivalSeen
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Survival Mode")
		ModEvent.Send(handle)
	elseif !sotwSeen && !PlayerREF.IsInInterior() && () && (CurrentPlayerWorldspace == Tamriel || CurrentPlayerWorldspace == Solstheim || CurrentPlayerWorldspace == Bruma)
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Skills of the Wild")
		ModEvent.Send(handle)
	endif
EndEvent

Event OnExplainerCallback(string name, bool accepted)
	if name == "About Blessings"
		if accepted
			ShowExplainer(BlessingExplainer)
		endif
		bleesingsSeen = true
	elseif name == "Finding Your Way"
		if accepted
			ShowExplainer(TravelExplainer)
		endif
		travelSeen = true
	elseif name == "Survival Mode"
		if accepted
			ShowExplainer(SurvivalExplainer)
		endif
		survivalSeen = true
	elseif name == "Skills of the Wild"
		if accepted
			ShowExplainer(SOTWExplainer)
		endif
		sotwSeen = true
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
