Scriptname CE_Experience_Manager extends ReferenceAlias

Import PO3_Events_Alias
Import Experience

Keyword Property CrafterAlchemy Auto
Keyword Property CrafterGrindstone Auto
Keyword Property CrafterWorkbench Auto
Keyword Property CrafterForge Auto
Keyword Property CrafterTanning Auto
Keyword Property CrafterEnchanting Auto
Keyword Property CrafterCookPot Auto
Keyword Property CrafterAHO Auto
Keyword Property CrafterCampfire Auto
Keyword Property CrafterSurvival Auto
Keyword Property CrafterLoom Auto
Keyword Property CrafterSkyForge Auto
Keyword Property CrafterLunarForge Auto
Keyword Property CrafterAetherium Auto
Keyword Property CrafterOven Auto
Keyword Property CrafterNecromancy Auto
Keyword Property CrafterBuildingWorkbench Auto
Keyword Property CrafterBYOHDrafting Auto
Keyword Property CrafterBYOHCarpenter Auto
Keyword Property CrafterStaffSoul Auto
Keyword Property CrafterStaffHeartstone Auto
Keyword Property CrafterScroll Auto

Keyword Property Jewelry Auto
Keyword Property JewelryExpensive Auto
Keyword Property BaseExp Auto
Keyword Property BasicExp Auto
Keyword Property JourneymanExp Auto
Keyword Property RareExp Auto
Keyword Property ExoticExp Auto
Keyword Property MythicExp Auto

GlobalVariable Property EasyCurve Auto

Keyword Property NoCraftingExperience Auto 

int ExperienceVersion

Event OnInit()
    RegisterForItemCrafted(Self)
	ExperienceVersion = SKSE.GetPluginVersion("experience")
	if !Game.IsPluginInstalled("leveling freedom.esp")
		if EasyCurve.getValue() == 1
			Game.SetGameSettingFloat("fXPLevelUpBase", 300)
			Game.SetGameSettingFloat("fXPLevelUpMult", 8)
		else
			Game.SetGameSettingFloat("fXPLevelUpBase", 375)
			Game.SetGameSettingFloat("fXPLevelUpMult", 10)
		endif
	endif
EndEvent

Event OnPlayerLoadGame()
    RegisterForItemCrafted(Self)
	ExperienceVersion = SKSE.GetPluginVersion("experience")
	if !Game.IsPluginInstalled("leveling freedom.esp")
		if EasyCurve.getValue() == 1
			Game.SetGameSettingFloat("fXPLevelUpBase", 300)
			Game.SetGameSettingFloat("fXPLevelUpMult", 8)
		else
			Game.SetGameSettingFloat("fXPLevelUpBase", 375)
			Game.SetGameSettingFloat("fXPLevelUpMult", 10)
		endif
	endif
EndEvent

Event OnItemCrafted(ObjectReference Crafter, Location _, Form Item)
	float mult = 1.0
	
	if Crafter.hasKeyword(CrafterGrindstone) || Crafter.hasKeyword(CrafterWorkbench)
		Game.advanceSkill("Smithing", 30)
		return
	endif
	
	if Crafter.hasKeyword(CrafterLunarForge) || Crafter.hasKeyword(CrafterSkyForge)
		mult = mult + 0.25
	endif
	
	if ExperienceVersion == -1 || Item.hasKeyword(NoCraftingExperience)
		return
	endif
	
	if Crafter.hasKeyword(CrafterAetherium)
		AddExperience(math.ceiling(20 * mult))
		Game.advanceSkill("Smithing", math.floor(25 * mult))
		return
	endif
	
	if Crafter.hasKeyword(CrafterForge)
		if Item.hasKeyword(MythicExp)
			AddExperience(math.ceiling(15 * mult))
			Game.advanceSkill("Smithing", math.floor(50 * mult))
		elseif Item.hasKeyword(ExoticExp)
			AddExperience(math.ceiling(12 * mult))
			Game.advanceSkill("Smithing", math.floor(30 * mult))
		elseif Item.hasKeyword(RareExp)
			AddExperience(math.ceiling(10 * mult))
			Game.advanceSkill("Smithing", math.floor(20 * mult))
		elseif Item.hasKeyword(JourneymanExp) || Item.hasKeyword(JewelryExpensive)
			AddExperience(math.ceiling(8 * mult))
		elseif Item.hasKeyword(BasicExp) || Item.hasKeyword(Jewelry)
			AddExperience(math.ceiling(6 * mult))
		elseif Item.hasKeyword(BaseExp) 
			AddExperience(math.ceiling(4 * mult))
		else
			AddExperience(math.ceiling(2 * mult))
		endif
		return
	endif
	
	if Crafter.hasKeyword(CrafterAlchemy) || \
	   Crafter.hasKeyword(CrafterEnchanting) || \
	   Crafter.hasKeyword(CrafterStaffSoul) || \
	   Crafter.hasKeyword(CrafterStaffHeartstone) || \
	   Crafter.hasKeyword(CrafterBYOHCarpenter) || \
	   Crafter.hasKeyword(CrafterBYOHDrafting) || \
	   Crafter.hasKeyword(CrafterBuildingWorkbench) || \
	   Crafter.hasKeyword(CrafterTanning) || \
	   Crafter.hasKeyword(CrafterAHO) || \
	   Crafter.hasKeyword(CrafterNecromancy) || \
	   Crafter.hasKeyword(CrafterLoom)
		AddExperience(5)
		return
	endif
	
	if Crafter.hasKeyword(CrafterScroll) && Item as Scroll
		AddExperience(5)
	endif
	
	if Crafter.hasKeyword(CrafterCookPot) || \
	   Crafter.hasKeyword(CrafterSurvival) || \
	   Crafter.hasKeyword(CrafterCampfire) || \
	   Crafter.hasKeyword(CrafterOven)
		AddExperience(3)
		return
	endif
	
EndEvent
