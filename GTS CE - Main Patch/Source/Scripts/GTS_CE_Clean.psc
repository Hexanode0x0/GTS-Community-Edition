Scriptname GTS_CE_Clean Extends ActiveMagicEffect

;Spell Property Dirty_SoapEffectSpell Auto
Spell Property Dirty_Spell_Blood1 Auto
Spell Property Dirty_Spell_Blood2 Auto
Spell Property Dirty_Spell_Blood3 Auto
Spell Property Dirty_Spell_Blood4 Auto
Spell Property Dirty_Spell_Clean Auto
Spell Property Dirty_Spell_Dirt1 Auto
Spell Property Dirty_Spell_Dirt2 Auto
Spell Property Dirty_Spell_Dirt3 Auto
Spell Property Dirty_Spell_Dirt4 Auto
bool Property isGreater Auto

Event OnEffectStart(Actor _, Actor __)
	Actor playerRef = Game.getPlayer()
	playerRef.RemoveSpell(Dirty_Spell_Dirt1)
    playerRef.RemoveSpell(Dirty_Spell_Dirt2)
    playerRef.RemoveSpell(Dirty_Spell_Dirt3)
    playerRef.RemoveSpell(Dirty_Spell_Dirt4)
    playerRef.RemoveSpell(Dirty_Spell_Blood1)
    playerRef.RemoveSpell(Dirty_Spell_Blood2)
    playerRef.RemoveSpell(Dirty_Spell_Blood3)
    playerRef.RemoveSpell(Dirty_Spell_Blood4)
	if isGreater
		playerRef.addSpell(Dirty_Spell_Clean, false)
	else
		playerRef.addSpell(Dirty_Spell_Dirt1, false)
	endif
EndEvent
