Scriptname GTS_BalanceGearScript Extends objectReference

Import b612

Message Property GTS_EasyModeMessage Auto

_SMI_SkillTreeAliasScript Property _SMI_PlayerAlias Auto

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
GlobalVariable Property CE_BlockExplainers Auto
GlobalVariable Property _RemovePelts Auto
GlobalVariable Property CE_EasySpellLearn Auto
GlobalVariable Property HideCompass Auto
GlobalVariable Property HideSneak Auto
GlobalVariable Property CE_ShowOriginQuest Auto
GlobalVariable Property CE_EasyHunger Auto
GlobalVariable Property CE_EasyExhaustion Auto
GlobalVariable Property CE_EasyWerewolfFeed Auto

GlobalVariable Property _WWW_PerkRank_SixthSense Auto
GlobalVariable Property _WWW_PerkRank_SpatialAwareness Auto

Spell Property _CrossHairSneak Auto
Spell Property ExtraCWForPlayer Auto
Spell Property CE_HealthRate Auto
Spell Property CE_StaminaRate Auto
Spell Property CE_MagickaRate Auto
Spell Property CE_FreeFastTravel Auto
Spell Property CE_EasyWarmth Auto

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
bool easySneak
bool easyVampireHate
bool easyFollowerDeath
bool easyRestrictShrine
bool easyLevelling
bool easyExplainer
bool easyHealth
bool easyStamina
bool easyMagicka
bool easySkinning
bool easyFastTravel
bool easySpellLearn
bool easyOriginQuest
bool easyWarmth
bool easyHunger
bool easyExhaustion
bool easyWerewolf

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
	easySneak = false
	easyVampireHate = false
	easyFollowerDeath = false
	easyRestrictShrine = false
	easyLevelling = false
	easyExplainer = false
	easyHealth = false
	easyStamina = false
	easyMagicka = false
	easySkinning = false
	easyFastTravel = false
	easySpellLearn = false
	easyOriginQuest = false
	easyWarmth = false
    easyHunger = false
    easyExhaustion = false
	easyWerewolf = false
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
	easySneak = true
	easyVampireHate = true
	easyFollowerDeath = true
	;Use GTS' story mode settings
	easyStress = false
	easyRestrictShrine = false
	easyLevelling = false
	easyExplainer = false
	easyHealth = false
	easyStamina = false
	easyMagicka = false
	easySkinning = false
	easyFastTravel = false
	easySpellLearn = false
	easyOriginQuest = false
	easyWarmth = false
    easyHunger = false
    easyExhaustion = false
	easyWerewolf = false
elseif iButton == 2
	;Custom
	GetSpinicon().Show("Loading")
	Game.DisablePlayerControls(true, true, false, true, true, true, true)
	MagicOrb.Disable(true)
	EasyOrb.Disable(true)
	CustomOrb.Enable(true)

	;Set dynamic strings
	String StaminaTitle = "No Attack Stamina Cost"
	String StaminaDesc = "Light attacks will not cost Stamina."
	String StressTitle = "Alternate Stress"
	String StressDesc = "Instead of stress decreasing Stamina and Magicka, low stress will provide small buffs while high stress will provide debuffs.<br>Buffs and debuffs are primarily for crafting and market dwelling, with an increase to damage received at high stress."
	if Game.IsPluginInstalled("Honor in Death - GTS CE Patch.esp")
		StaminaTitle = "Lower Attack Stamina Cost"
		StaminaDesc = "Light attacks will cost half as much Stamina."
		StressTitle = "Default Stress"
		StressDesc = "Instead of stress providing buffs when low and debuffs when high, stress will decrease Stamina and Magicka as it rises.<br>Buffs and debuffs are primarily for crafting and market dwelling, with an increase to damage received at high stress."
	endif
	;set to default
	easySunDamage = false
	easyCarryWeight = false
	easySneakStamina = false
	easyAttackStamina = false
	easyNpcPotion = false
	easyPlayerPotion = false
	easyStress = false
	easyCompass = false
	easySneak = false
	easyVampireHate = true
	easyFollowerDeath = false
	easyRestrictShrine = false
	easyLevelling = false
	easyExplainer = false
	easyHealth = false
	easyStamina = false
	easyMagicka = false
	easySkinning = false
	easyFastTravel = false
	easySpellLearn = false
	easyOriginQuest = false
	easyWarmth = false
    easyHunger = false
    easyExhaustion = false
	easyWerewolf = false

	b612_TraitsMenu DifficultyMenu = GetTraitsMenu()
	DifficultyMenu.AddItem("No Sun Damage", "If you become a Vampire, you will not receive damage from being exposed to the sun.<br>NPC Vampires are always damaged by sunlight.", "")
	DifficultyMenu.AddItem("Additional Carry Weight", "You will get an additional 100 carry weight.", "")
	DifficultyMenu.AddItem("No Sneak Stamina Cost", "Moving while sneaking will not cost Stamina.", "")
	DifficultyMenu.AddItem(StaminaTitle, StaminaDesc, "")
	DifficultyMenu.AddItem("Less NPC Potions", "NPCs will carry less potions to heal themselves with.", "")
	DifficultyMenu.AddItem("Starting Empty Bottles", "You will get an additional 20 empty bottles to enable your alchemy.", "")
	DifficultyMenu.AddItem(StressTitle, StressDesc, "")
	DifficultyMenu.AddItem("Early Compass", "The compass and player map marker will be visible without the relevant campfire perks.", "")
	DifficultyMenu.AddItem("Early Sneak Meter", "The sneak eye will be visible without the relevant campfire perks.", "")
	DifficultyMenu.AddItem("No Stage Four Vampire Hate", "If you are a feral, stage four Vampire, you will not be hated and attacked on sight.", "")
	DifficultyMenu.AddItem("Follower Immunity", "Followers will not receive injuries or be able to die.", "")
	DifficultyMenu.AddItem("Free Blessings", "Blessings will not be denied if you have not met the deity's requirements.", "")
	DifficultyMenu.AddItem("Faster Levelling", "Enable a more accelerated levelling curve. Only affects experience needed for a level increase, skills remain unaffected.", "")
	DifficultyMenu.AddItem("Disable Explainers", "Explaners are minor text tutorials that will pop up when you interact with the relevant mechanic. Select this option to disable them.", "")
	DifficultyMenu.AddItem("Faster Health Regen", "Additional Health regeneration. Scales with enchantments, potions or other effects.", "")
	DifficultyMenu.AddItem("Faster Stamina Regen", "Additional Stamina regeneration. Scales with enchantments, potions or other effects.", "")
	DifficultyMenu.AddItem("Faster Magicka Regen", "Additional Magicka regeneration. Scales with enchantments, potions or other effects.", "")
	DifficultyMenu.AddItem("Disable Animal Skinning", "When you loot a pelt from an animal, it will swap to a fleshy texture. Select this to disable the swap.", "")
	DifficultyMenu.AddItem("Free Fast Travel", "Removes the Travel Pack requirement for fast travel.", "")
	DifficultyMenu.AddItem("Instant Spell Learning", "Normally, it takes some time to learn spells. Longer the larger the gap between the spell's level and yours.<br>This option makes learing spells instant.", "")
	DifficultyMenu.AddItem("Origin Quest Marker", "Show a quest marker for the origin quest, if it has one.", "")
	DifficultyMenu.AddItem("Slower Cold", "You won't lose as much warmth is cold weather.", "")
	DifficultyMenu.AddItem("Slower Hunger", "Hunger will progress more slowly.", "")
	DifficultyMenu.AddItem("Slower Exhaustion", "You can stay up longer before you're exhausted and need to sleep.", "")
	DifficultyMenu.AddItem("No Werewolf Feed Limit", "As a werewolf, you will be able to feed on bodies, even if you're full.", "")
	GetSpinicon().Hide()
	Game.EnablePlayerControls()
	;Max selections, min selections
	string[] chosen = DifficultyMenu.Show(25, 0)
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
				easySneak = true
			elseif index == 9
				easyVampireHate = true
			elseif index == 10
				easyFollowerDeath = true
			elseif index == 11
				easyRestrictShrine = true
			elseif index == 12
				easyLevelling = true
			elseif index == 13
				easyExplainer = true
			elseif index == 14
				easyHealth = true
			elseif index == 15
				easyStamina = true
			elseif index == 16
				easyMagicka = true
			elseif index == 17
				easySkinning = true
			elseif index == 18
				easyFastTravel = true
			elseif index == 19
				easySpellLearn = true
			elseif index == 20
				easyOriginQuest = true
			elseif index == 21
				easyWarmth = true
			elseif index == 22
				easyHunger = true
			elseif index == 23
				easyExhaustion = true
			elseif index == 24
				easyWerewolf = true
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

	if easyCompass || _WWW_PerkRank_SpatialAwareness.GetValue() != 0
	    HideCompass.SetValue(0)
		CompassCheat.SetValue(1)
	else
	    HideCompass.SetValue(1)
		CompassCheat.SetValue(0)
	endif

	if easySneak || _WWW_PerkRank_SixthSense.GetValue() != 0
		HideSneak.SetValue(0)
	else
		HideSneak.SetValue(1)
	endif

	;Set to 1 for hate to happen
	if easyVampireHate
		GTS_Stage4_Hate.SetValue(0)
	else
		GTS_Stage4_Hate.SetValue(1)
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

	if easyExplainer
		CE_BlockExplainers.SetValue(1)
	else
		CE_BlockExplainers.SetValue(0)
	endif

	if easyHealth
		PlayerRef.AddSpell(CE_HealthRate, false)
	else
		PlayerRef.RemoveSpell(CE_HealthRate)
	endif

	if easyStamina
		PlayerRef.AddSpell(CE_StaminaRate, false)
	else
		PlayerRef.RemoveSpell(CE_StaminaRate)
	endif

	if easyMagicka
		PlayerRef.AddSpell(CE_MagickaRate, false)
	else
		PlayerRef.RemoveSpell(CE_MagickaRate)
	endif

	if easySkinning
		;inverted
		_RemovePelts.SetValue(0)
	else
		_RemovePelts.SetValue(1)
	endif

	if easyFastTravel
		PlayerRef.AddSpell(CE_FreeFastTravel, false)
	else
		PlayerRef.RemoveSpell(CE_FreeFastTravel)
	endif

	if easySpellLearn
		CE_EasySpellLearn.SetValue(1)
	else
		CE_EasySpellLearn.SetValue(0)
	endif

	if easyOriginQuest
		CE_ShowOriginQuest.SetValue(1)
	else
		CE_ShowOriginQuest.SetValue(0)
	endif

	if easyWarmth
	    PlayerRef.AddSpell(CE_EasyWarmth, false)
	else
		PlayerRef.RemoveSpell(CE_EasyWarmth)
	endif

	if easyHunger && CE_EasyHunger.GetValue() == 0
	    _SMI_PlayerAlias.UpdateResistance(0.25, 0)
		CE_EasyHunger.SetValue(1)
	elseif !easyHunger && CE_EasyHunger.GetValue() == 1
	    _SMI_PlayerAlias.UpdateResistance(-0.25, 0)
		CE_EasyHunger.SetValue(0)
	endif

	if easyExhaustion && CE_EasyExhaustion.GetValue() == 0
	    _SMI_PlayerAlias.UpdateResistance(0.25, 1)
		CE_EasyExhaustion.SetValue(1)
	elseif !easyExhaustion && CE_EasyExhaustion.GetValue() == 1
	    _SMI_PlayerAlias.UpdateResistance(-0.25, 1)
		CE_EasyExhaustion.SetValue(0)
	endif
	
	if easyWerewolf
	    CE_EasyWerewolfFeed.SetValue(1)
	else
		CE_EasyWerewolfFeed.SetValue(0)
	endif

EndFunction
