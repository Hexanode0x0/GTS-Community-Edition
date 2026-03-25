Scriptname GTS_BalanceGearScript extends objectReference

Import b612

Message Property GTS_EasyModeMessage Auto

ObjectReference Property MagicOrb Auto
ObjectReference Property EasyOrb Auto
ObjectReference Property CustomOrb Auto

GlobalVariable Property GTS_EasySunDamage Auto
GlobalVariable Property NPCpotion_MaxPotion Auto
GlobalVariable Property GTS_Stage4_Hate Auto
GlobalVariable Property CompassCheat Auto
GlobalVariable Property HexStress Auto
GlobalVariable Property SneakStamina Auto
GlobalVariable Property AttackStamina Auto
GlobalVariable Property FollowerDeath Auto
GlobalVariable Property RestrictShrine Auto
GlobalVariable Property NoCheat Auto
GlobalVariable Property SwitchLock Auto
GlobalVariable Property EasyLevel Auto

Spell Property _CrossHairSneak Auto
Spell Property ExtraCWForPlayer Auto

MiscObject Property _p7ARBR_EmptyBottle Auto

Actor Property PlayerRef Auto

bool easySunDamage
bool easyCarryWeight
bool easySneakStamina
bool easyAttackStamina
bool easyNpcPotion
bool easyPlayerPotion
bool easyStress
bool easyCompass
bool easyVampireHate
bool easyFollowerDeath
bool easyRestrictShrine
bool easyLevelling

Event OnActivate(ObjectReference akActionRef)
if SwitchLock.GetValue() == 1
	return
else
	SwitchLock.SetValue(1)
endif
Message msgbox = GTS_EasyModeMessage
Int iButton = GTS_EasyModeMessage.Show()

if ibutton == 0
	;Default Experience
	MagicOrb.Enable(true)
	EasyOrb.Disable(true)
	CustomOrb.Disable(true)
	
	easySunDamage = false
	easyCarryWeight = false
	easySneakStamina = false
	easyAttackStamina = false
	easyNpcPotion = false
	easyPlayerPotion = false
	easyStress = false
	easyCompass = false
	;Note: this is true on default. Thanks Jay.
	easyVampireHate = true
	easyFollowerDeath = false
	easyRestrictShrine = false
	easyLevelling = false
elseif ibutton == 1
	;Easy Mode
	MagicOrb.Disable(true)
	EasyOrb.Enable(true)
	CustomOrb.Disable(true)

	easySunDamage = true
	easyCarryWeight = true
	easySneakStamina = true
	easyAttackStamina = true
	easyNpcPotion = true
	easyPlayerPotion = true
	easyCompass = true
	;Note: this is false on story. Thanks Jay.
	easyVampireHate = false
	easyFollowerDeath = true
	;Use GTS' story mode settings
	easyStress = false
	easyRestrictShrine = false
	easyLevelling = false
elseif iButton == 2
	;Custom
	GetSpinicon().Show("Loading")
	Game.DisablePlayerControls(true, true, false, true, true, true, true)
	MagicOrb.Disable(true)
	EasyOrb.Disable(true)
	CustomOrb.Enable(true)
	
	;set to default
	easySunDamage = false
	easyCarryWeight = false
	easySneakStamina = false
	easyAttackStamina = false
	easyNpcPotion = false
	easyPlayerPotion = false
	easyStress = false
	easyCompass = false
	easyVampireHate = true
	easyFollowerDeath = false
	easyRestrictShrine = false
	easyLevelling = false
	
	b612_TraitsMenu DifficultyMenu = GetTraitsMenu()
	DifficultyMenu.AddItem("No Sun Damage", "If you become a Vampire, you will <b>not</b> recieve damage from being exposed to the sun.<br>NPC Vampires are always damaged by sunlight.", "")
	DifficultyMenu.AddItem("Additonal Carry Weight", "You will get an additional 100 carry weight.", "")
	DifficultyMenu.AddItem("No Sneak Stamina Cost", "Moving while sneaking will <b>not</b> cost Stamina.", "")
	DifficultyMenu.AddItem("No Attack Stamina Cost", "Light attacks will <b>not</b> cost Stamina.", "")
	DifficultyMenu.AddItem("Less NPC Potions", "NPCs will carry less potions to heal themselves with.", "")
	DifficultyMenu.AddItem("Starting Empty Bottles", "You will get an additional 20 empty bottles to enable your alchemy.", "")
	DifficultyMenu.AddItem("Alternate Stress", "Instead of stress decreasing Stamina and Magicka, low stress will provide small buffs while high stress will provide debuffs.<br>Buffs and debuffs are primarly for crafting and market dwelling, with an increase to damage recieved at high stress.", "")
	DifficultyMenu.AddItem("Early Compass", "The compass, sneak eye, and player map marker will be visible without the relevant campfire perks.", "")
	DifficultyMenu.AddItem("No Stage Four Vampire Hate", "If you are a feral, stage four Vampire, you will <b>not</b> be hated and attacked on sight.", "")
	DifficultyMenu.AddItem("Follower Immunity", "Followers will <b>not</b> recieve injuries or be able to die.", "")
	DifficultyMenu.AddItem("Free Blessings", "Blessings will not be denied if you have not met the deity's requirements.", "")
	DifficultyMenu.AddItem("Smoother Levelling", "Enable a more gentle levelling curve. Mitigates the progression slump in midgame. Only affects experience needed for a level increase, skills remain unaffected.", "")
	GetSpinicon().Hide()
	Game.EnablePlayerControls()
	;Max selections, min selections
	string[] chosen = DifficultyMenu.Show(12, 0)
	int i = 0
	if !chosen.length == 0
		while i < chosen.length
			int index = chosen[i] as int
			if index == 0
				easySunDamage = true
			elseif index == 1
				easyCarryWeight = true
			elseif index == 2
				easySneakStamina = true
			elseif index == 3
				easyAttackStamina = true
			elseif index == 4
				easyNpcPotion = true
			elseif index == 5
				easyPlayerPotion = true
			elseif index == 6
				easyStress = true
			elseif index == 7
				easyCompass = true
			elseif index == 8
				easyVampireHate = false
			elseif index == 9
				easyFollowerDeath = true
			elseif index == 10
				easyRestrictShrine = true
			elseif index == 11
				easyLevelling = true
			else
				Debug.notification("Failed to apply changes. Report this to GTS-CE authors")
			endif
			i = i + 1
		endwhile
	endif
endif
changeDifficulty()
SwitchLock.SetValue(0)
Endevent

Function changeDifficulty()
	if easySunDamage
		GTS_EasySunDamage.SetValue(1)
	else
		GTS_EasySunDamage.SetValue(0)
	endif
	
	if easyCarryWeight
		PlayerRef.AddSpell(ExtraCWForPlayer, false)
	else
		PlayerRef.RemoveSpell(ExtraCWForPlayer)
	endif
	
	if easySneakStamina
		SneakStamina.SetValue(1)
	else
		SneakStamina.SetValue(0)
	endif
	
	if easyAttackStamina
		AttackStamina.SetValue(1)
	else
		AttackStamina.SetValue(0)
	endif

	if easyNpcPotion
		NPCpotion_MaxPotion.SetValue(1)
	else
		NPCpotion_MaxPotion.SetValue(4)
	endif
	
	if easyPlayerPotion
		if NoCheat.getValue() == 0
			PlayerRef.AddItem(_p7ARBR_EmptyBottle, 20, true)
			NoCheat.SetValue(1)
		endif
	else
		if PlayerRef.getItemCount(_p7ARBR_EmptyBottle) >= 20
			PlayerRef.RemoveItem(_p7ARBR_EmptyBottle, 20, true)
			NoCheat.SetValue(0)
		endif
	endif
	
	if easyStress
		HexStress.SetValue(1)
	else
		HexStress.SetValue(0)
	endif
	
	if easyCompass
		UI.SetFloat("HUD Menu", "_root.HUDMovieBaseInstance.StealthMeterInstance._alpha", 100)
		UI.SetFloat("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder._alpha", 100)
		PlayerRef.Removespell(_CrossHairSneak)
		CompassCheat.SetValue(1)
	else
		UI.SetFloat("HUD Menu", "_root.HUDMovieBaseInstance.StealthMeterInstance._alpha", 0)
		UI.SetFloat("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder._alpha", 0)
		PlayerRef.AddSpell(_CrossHairSneak, false)
		CompassCheat.SetValue(0)
	endif
	
	if easyVampireHate
		GTS_Stage4_Hate.SetValue(1)
	else
		GTS_Stage4_Hate.SetValue(0)
	endif
	
	if easyFollowerDeath
		FollowerDeath.SetValue(1)
	else
		FollowerDeath.SetValue(0)
	endif

	if easyRestrictShrine
		RestrictShrine.SetValue(1)
	else
		RestrictShrine.SetValue(0)
	endif
	
	if easyLevelling && !Game.IsPluginInstalled("leveling freedom.esp")
		EasyLevel.SetValue(1)
		Game.SetGameSettingFloat("fXPLevelUpBase", 300)
		Game.SetGameSettingFloat("fXPLevelUpMult", 8)
	else
		EasyLevel.SetValue(0)
		Game.SetGameSettingFloat("fXPLevelUpBase", 375)
		Game.SetGameSettingFloat("fXPLevelUpMult", 10)
	endif
EndFunction