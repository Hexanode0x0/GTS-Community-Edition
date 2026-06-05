Scriptname CE_Spell_Resist_Tracker extends ReferenceAlias

import PO3_Events_Alias

Actor Property PlayerTracker Auto
Formlist Property KeywordsToWatch Auto
GlobalVariable Property CE_BlockExplainers Auto

Int ArmorRating
Float MagicResist

bool bleesingsSeen = false
bool bardSeen = false
bool woundsSeen = false
bool fearSeen = false
bool werewolfSeen = false
bool vampirismSeen = false

Event OnInit()
	RegisterForMenu("TweenMenu")
	RegisterForMagicEffectApplyEx(self, KeywordsToWatch, true)
EndEvent

Event OnMenuOpen(string _)
	ArmorRating = PlayerTracker.GetAV("DamageResist") as Int
	if ArmorRating < 501
		MagicResist = 0.05 * ArmorRating
	elseif ArmorRating > 999
		MagicResist = 40
	else
		MagicResist = 25 + 0.03 * (ArmorRating - 500)
	endif
	PlayerTracker.SetAV("Variable05", Math.Floor(MagicResist))
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
