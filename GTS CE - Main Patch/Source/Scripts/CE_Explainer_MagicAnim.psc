Scriptname CE_Explainer_MagicAnim Extends ReferenceAlias

import PO3_Events_Alias

bool bleesingsSeen = false
bool bardSeen = false
bool woundsSeen = false
bool fearSeen = false
bool werewolfSeen = false
bool vampirismSeen = false
bool spellLearnSeen = false
bool horseSeen = false

bool registeredForAnim = false

Message[] Property BlessingExplainer Auto
Message[] Property BardExplainer Auto
Message[] Property WoundsExplainer Auto
Message[] Property FearExplainer Auto
Message[] Property VampirismExplainer Auto
Message[] Property WerewolfExplainer Auto
Message[] Property SpellLearnExplainer Auto
Message[] Property HorseExplainer Auto

GlobalVariable Property CE_BlockExplainers Auto
Actor Property PlayerREF Auto
Formlist Property KeywordsToWatch Auto
Location Property DreamOfSovngarde Auto

Event OnInit()
	RegisterForModEvent("CE_Explainer_Callback", "OnExplainerCallback")
	RegisterForCellFullyLoaded(self)
	RegisterForModEvent("CE_Spell_Learned", "OnCESpellLearned")
EndEvent

Event OnCellFullyLoaded(cell loaded_cell)
	if PlayerREF.GetCurrentLocation() != DreamOfSovngarde
		utility.wait(3)
		RegisterForMagicEffectApplyEx(self, KeywordsToWatch, true)
		if !registeredForAnim
			registeredForAnim = RegisterForAnimationEvent(PlayerREF, "tailHorseMount")
		endif

		if registeredForAnim
		    UnregisterForCellFullyLoaded(self)
		endif
	endif
EndEvent

Event OnCESpellLearned()
	;debug.notification("MAGICEFFECT: spell learned fired")
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
		UnregisterForModEvent("CE_Spell_Learned")
	endif
EndEvent

Event OnMagicEffectApplyEx(ObjectReference caster, MagicEffect effect, Form source, bool applied)
	if CE_BlockExplainers.GetValue() == 1
		return
	endif

	if !bleesingsSeen && (effect.hasKeyword(KeywordsToWatch.getAt(0) as Keyword) || effect.hasKeyword(KeywordsToWatch.getAt(1) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "About Blessings")
		bleesingsSeen = true
		Utility.Wait(5)
		ModEvent.Send(handle)
	elseif !bardSeen && (effect.hasKeyword(KeywordsToWatch.GetAt(2) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Playing Music")
		bardSeen = true
		Utility.Wait(10)
		ModEvent.Send(handle)
	elseif !woundsSeen && (effect.hasKeyword(KeywordsToWatch.GetAt(3) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Injuries and Wounds")
		ModEvent.Send(handle)
		woundsSeen = true
	elseif !fearSeen && (effect.hasKeyword(KeywordsToWatch.GetAt(4) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "About Fear")
		ModEvent.Send(handle)
		fearSeen = true
	elseif !werewolfSeen && (effect.hasKeyword(KeywordsToWatch.GetAt(5) as Keyword))
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Lycanthropy")
		werewolfSeen = true
		Utility.Wait(5)
		ModEvent.Send(handle)
	elseif !vampirismSeen && (effect.hasKeyword(KeywordsToWatch.GetAt(6) as Keyword))
	    Utility.Wait(10)
		int handle = ModEvent.Create("CE_Explainer")
		ModEvent.PushString(handle, "Vampirism")
		vampirismSeen = true
		ModEvent.Send(handle)
	endif

	if werewolfSeen && fearSeen && woundsSeen && bardSeen && bleesingsSeen && vampirismSeen
		UnregisterForAllMagicEffectApplyEx(self)
	endif
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	;debug.notification("MAGICANIM: animation event fired")
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

Event OnExplainerCallback(string name, bool accepted)
	if !accepted
		return
	endif

	if name == "About Blessings"
		ShowExplainer(BlessingExplainer)
	elseif name == "Playing Music"
		ShowExplainer(BardExplainer)
	elseif name == "Injuries and Wounds"
		ShowExplainer(WoundsExplainer)
	elseif name == "About Fear"
		ShowExplainer(FearExplainer)
	elseif name == "Vampirism"
		ShowExplainer(VampirismExplainer)
	elseif name == "Lycanthropy"
		ShowExplainer(WerewolfExplainer)
	elseif name == "Learning Spells"
		ShowExplainer(SpellLearnExplainer)
	elseif name == "Horses"
		ShowExplainer(HorseExplainer)
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
