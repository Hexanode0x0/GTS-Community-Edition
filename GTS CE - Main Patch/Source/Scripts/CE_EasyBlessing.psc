Scriptname CE_EasyBlessing Extends ActiveMagicEffect

Spell Property CE_BlessingSpell Auto
Actor Property PlayerREF Auto

Event OnEffectStart(Actor target, Actor caster)
	CE_BlessingSpell.Cast(PlayerREF, PlayerREF)
EndEvent
