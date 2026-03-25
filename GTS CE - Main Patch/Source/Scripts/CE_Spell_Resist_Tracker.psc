Scriptname CE_Spell_Resist_Tracker extends referenceAlias

Actor Property PlayerTracker Auto

Int ArmorRating
Float MagicResist

Event OnInit()
	RegisterForMenu("TweenMenu")
EndEvent

Event OnMenuOpen(String _)
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
