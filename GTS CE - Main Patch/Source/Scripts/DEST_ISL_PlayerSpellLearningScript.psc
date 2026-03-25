Scriptname DEST_ISL_PlayerSpellLearningScript extends ReferenceAlias

import DEST_AliasExt
import DEST_UIExt

GlobalVariable Property GameHour auto

Formlist Property LastSpellTome Auto
Formlist Property SpellTome_Whitelist Auto

GlobalVariable Property hoursToMaster Auto
GlobalVariable Property hoursStudiedTotal Auto
GlobalVariable Property exhaustionPerHour Auto
GlobalVariable Property hoursLeft Auto

Message property StudyDaysMessage Auto
Message property StudyMonthsMessage Auto
Message property StudyContinueMessage Auto
Message property StudyStartMessage Auto
Message property StudyForgetMessage Auto
Message property ForgetSpellMessage Auto
Message property MagReqMessage Auto
Message property SchoolReqMessage Auto
Message property FPStudyDaysMessage Auto
Message property FPStudyMonthsMessage Auto
Message property FPStudyContinueMessage Auto
Message property FPStudyStartMessage Auto
Message property FPStudyForgetMessage Auto
Message property FPForgetSpellMessage Auto
Message property FPMagReqMessage Auto
Message property FPSchoolReqMessage Auto

Location Property WinterholdCollegeLocation auto
Location Property WinterholdCollegeArcanaeumLocation auto

MagicEffect Property RestedSkillEffect auto
MagicEffect Property RestedWellSkillEffect auto
MagicEffect Property BookwormTraitEffect auto

Keyword Property LocTypeInn auto
Keyword Property LocTypePlayerHouse auto

Idle Property IdleBook_Reading auto
Idle Property IdleBookSitting_Reading auto
Idle Property IdleBook_TurnManyPages auto
Idle Property IdleBookSitting_TurnManyPages auto
Idle Property IdleStop_Loose Auto

ImageSpaceModifier Property FadeToBlackBackImod auto
ImageSpaceModifier Property FadeToBlackImod auto
ImageSpaceModifier Property FadeToBlackHoldImod auto

GlobalVariable Property playAnim auto
GlobalVariable Property FPerson auto
GlobalVariable Property fadeToBlack auto
GlobalVariable Property extraBonuses auto
GlobalVariable Property MagSkillReq auto
GlobalVariable Property timeMod auto
GlobalVariable Property forgetSpell auto
GlobalVariable Property BookwormTraitStudyBoost auto

GlobalVariable Property baseMagReq auto
GlobalVariable Property baseSchoolReq auto
GlobalVariable Property SkillExp auto
Actor PlayerRef
MagicEffect SpellMagEffect
string person = "You"

Event OnInit()
	PlayerRef = Game.GetPlayer()
	RegisterForSpellTomeReadEvent(self)
EndEvent

Event OnPlayerLoadGame()
	PlayerRef = Game.GetPlayer()
	UnregisterForSpellTomeReadEvent(self)
	Utility.Wait(0.3)	
	RegisterForSpellTomeReadEvent(self)
EndEvent

Event OnSpellTomeRead(Book akBook, Spell akSpell, ObjectReference akContainer)

	SpellMagEffect = akSpell.GetNthEffectMagicEffect(0)
	
	if MagSkillReq.GetValue()
		if PlayerRef.GetBaseActorValue("Magicka") < baseMagReq.getValue()
			if FPerson.GetValue()
				FPMagReqMessage.show()
			else
				MagReqMessage.show()
			endif
			return
		else
			if PlayerRef.getAV(SpellMagEffect.GetAssociatedSkill()) < baseSchoolReq.getValue()
				if FPerson.GetValue()
					FPSchoolReqMessage.show()
				else
					SchoolReqMessage.show()
				endif
				return
			endif
		endif
	endif
	
	if FPerson.GetValue()
		person = "I"
	else
		person = "You"
	endif
	
	int buttonPressed = -1
	
	if !PlayerRef.HasSpell(akSpell)
	
		if SpellTome_Whitelist.HasForm(akBook)
			PlayerRef.AddSpell(akSpell)
			return
		endif
		
		int forget = 0
		
		if !LastSpellTome.HasForm(akBook) && (LastSpellTome.GetSize() > 0 )
			if FPerson.GetValue()
				forget = FPStudyForgetMessage.Show()
			else
				forget = StudyForgetMessage.Show()
			endif
			if forget == 0
				return
			endif
		endif
	
		self.CalculatehoursToMaster(akSpell)
		
		hoursLeft.setValue(hoursToMaster.getValue() - hoursStudiedTotal.getValue())
		
		if hoursLeft.getValue() < 1
			hoursLeft.setValue(1)
		endif
		
		if  forget == 1 || hoursStudiedTotal.getValue() == 0
			buttonPressed = getHoursToStudy(hoursToMaster)
		else
			buttonPressed = getHoursToStudy(hoursLeft,false)
		endif
		
		if buttonPressed < 1
			return
		elseif forget == 1 || hoursStudiedTotal.getValue() == 0
			hoursStudiedTotal.setValue(0)
			LastSpellTome.Revert()
			LastSpellTome.AddForm(akBook)
		endif
		
		self.Study(buttonPressed, akSpell)
	else
		if forgetSpell.GetValue()
			if FPerson.GetValue()
				buttonPressed = FPForgetSpellMessage.Show()
			else
				buttonPressed = ForgetSpellMessage.Show()
			endif
			if buttonPressed < 1
				return
			else
				PlayerRef.RemoveSpell(akSpell)
				string sText = person + " have forgotten " + akSpell.GetName() + "."
				Debug.Notification(sText)
			endif
		else
			string sAlreadyKnown = Game.GetGameSettingString("sAlreadyKnown")
			string sText = sAlreadyKnown + " " + akSpell.GetName() + "."
			Debug.Notification(sText)
		endif
	endif

EndEvent

function CalculatehoursToMaster(Spell akSpell) ;D&D = 2 hours per level, check 10 + spell level
	Float SpellLevel = SpellMagEffect.GetSkillLevel()
	Float playerSchoolLevel = PlayerRef.getAV(SpellMagEffect.GetAssociatedSkill())
	Float mult = 1
	if extraBonuses.GetValue()
		mult = self.GetMultiplier()
	endif
	if SpellLevel < 5
		SpellLevel = 5
	endif
	if playerSchoolLevel < 2
		playerSchoolLevel = 2
	endif
;	float exp = SpellLevel / (math.pow(playerSchoolLevel, 1.3))
	float exp = math.sqrt(SpellLevel / playerSchoolLevel)
;	debug.notification("exp is:" + exp)
;	Int baseHours = Round(math.pow(SpellLevel, exp) * math.sqrt(SpellLevel))
	float baseHours = math.sqrt(math.pow(SpellLevel, exp)) * 2
;	debug.notification("base hour is:" + baseHours)

	hoursToMaster.setValue(Round(baseHours / mult * timeMod.GetValue()) as int);add here multipliers
;	Check for the bookworm trait
	if PlayerRef.hasMagicEffect(BookwormTraitEffect)
		hoursToMaster.setValue(Round(baseHours / mult * timeMod.GetValue() / BookwormTraitStudyBoost.GetValue()) as int);add here multipliers
	endif
	
	if hoursToMaster.getValue() < 1
		hoursToMaster.setValue(1)
	endif
endfunction

function Study(int hoursStudied, Spell akSpell)
	; Do all checks
	if (PlayerRef.IsInCombat())		;Check if player is in combat
		Debug.Notification(person + " cannot study while in combat.")
		return
	elseif (PlayerRef.IsTrespassing())		;Check if player is trespassing
		Debug.Notification(person + " cannot study whilst trespassing.")
		return
	endif

	Game.DisablePlayerControls() ; take away control from player and sheath weapons if needed
	
	if (PlayerRef.IsWeaponDrawn())
		PlayerRef.SheatheWeapon()
		Utility.Wait(1.5)
	endif
	
	int iCameraState
	int iCameraPluginVersion = SKSE.GetPluginVersion("ImprovedCameraSE")
	
	if playAnim.GetValue()
		TrueDirectionalMovement.ToggleDisableHeadtracking("DEST_ISL.esp", True)
		
		if (PlayerRef.GetSitState() >= 3)		; choose and begin animation
			If PlayerRef.GetAnimationVariableInt("i1stPerson") == 1 && iCameraPluginVersion < 0
				iCameraState = 1
				Game.ForceThirdPerson()
			EndIf
			
			PlayerRef.SetAnimationVariableInt("iGPMAOffsetType", 10)
			;PlayerRef.PlayIdle(IdleBookSitting_Reading)
			Debug.SendAnimationEvent(PlayerRef, "OffsetGPMA")
			Utility.Wait(3)
			PlayerRef.SetAnimationVariableInt("iGPMAOffsetType", 11)
			;PlayerRef.PlayIdle(IdleBookSitting_TurnManyPages)
		else
			If PlayerRef.GetAnimationVariableInt("i1stPerson") == 1
				PlayerRef.SetAnimationVariableInt("iGPMAOffsetType", 10)
				;PlayerRef.PlayIdle(IdleBookSitting_Reading)
				Debug.SendAnimationEvent(PlayerRef, "OffsetGPMA")
				Utility.Wait(3)
			else	
				PlayerRef.PlayIdle(IdleBook_Reading)
				Utility.Wait(3)
				PlayerRef.PlayIdle(IdleBook_TurnManyPages)
			EndIf
		endif
		
		TrueDirectionalMovement.ToggleDisableHeadtracking("DEST_ISL.esp", False)
	endif
	
	Utility.Wait(1)		; fade out and wait game time
	
	if fadeToBlack.GetValue()
	
		FadeToBlackImod.Apply()

		Utility.Wait(2.5)

		FadeToBlackHoldImod.Apply()

		GameHour.Mod(hoursStudied)
		Utility.Wait(1)
		
		FadeToBlackBackImod.Apply()		; fade back in and wait for the animation to finish
		FadeToBlackHoldImod.Remove()
	else
		float i = 0
		while i < hoursStudied
			GameHour.Mod(1)
			i += 1
			Utility.Wait(1)
		endwhile
	endif

	PlayerRef.SetAnimationVariableInt("iGPMAOffsetType", 10)

	Utility.Wait(2)
	
	hoursStudiedTotal.Mod(hoursStudied)		; update progress and notify the player
	
	if Game.GetFormFromFile(0x00000826, "ccqdrsse001-survivalmode.esl")
		globalvariable Survival_ModeEnabled = Game.GetFormFromFile(0x00000826, "ccqdrsse001-survivalmode.esl") as globalvariable
		if Survival_ModeEnabled.GetValue()
			(Quest.GetQuest("Survival_NeedExhaustionQuest") as survival_needexhaustion).IncreaseExhaustion(hoursStudied * exhaustionPerHour.getValue())
		endif
	endif
	
	; Not Needed - GTS CE. Causes problems while compiling.
	;if Game.GetFormFromFile(0x2EB63, "SunHelmSurvival.esp")
	;	globalvariable Survival_ModeEnabled = Game.GetFormFromFile(0x2EB63, "SunHelmSurvival.esp") as globalvariable
	;	globalvariable _SHFatigueShouldBeDisabled = Game.GetFormFromFile(0x752709, "SunHelmSurvival.esp") as globalvariable
	;	if Survival_ModeEnabled.GetValue() && !(_SHFatigueShouldBeDisabled.GetValue())
	;		(Quest.GetQuest("_SHFatigueQuest") as _SHFatigueSystem).IncreaseFatigueLevel(hoursStudied * exhaustionPerHour.getValue())
	;	endif
	;endif
	
	if SkillExp.getValue() > 0
		Game.AdvanceSkill(SpellMagEffect.GetAssociatedSkill(), SkillExp.getValue() * hoursStudied)
	endif
	
	if hoursStudied == 1
		Debug.Notification(person + " studied " + akSpell.GetName() + " for " + hoursStudied as Int + " hour.")
	else
		Debug.Notification(person + " studied " + akSpell.GetName() + " for " + hoursStudied as Int + " hours.")
	endif
	
	if hoursStudiedTotal.getValue() >= hoursToMaster.getValue() as int
		PlayerRef.AddSpell(akSpell, false)
		Debug.Notification(person + " have learned " + akSpell.GetName() + ".")
		LastSpellTome.Revert()
		hoursStudiedTotal.setValue(0)
	endif
	
	PlayerRef.playIdle(IdleStop_Loose)
	Debug.SendAnimationEvent(PlayerRef, "OffsetGPMAStop")
	PlayerRef.SetAnimationVariableInt("iGPMAOffsetType", 0)
	
	Utility.Wait(1)
	
	if playAnim.GetValue() && iCameraState == 1
		Game.ForceFirstPerson()
	endif
	
	Game.EnablePlayerControls()		; and return control to player
	
endfunction

int function Round(float f)
	Int resultFloor = math.floor(f)
	float diffFloor = math.abs(f - resultFloor)
	Int resultCeiling = math.ceiling(f)
	if diffFloor < 0.5
		return resultFloor
	else
		return resultCeiling
	endif
endfunction

float function GetMultiplier()
	float mult = 1
	
	mult += (PlayerRef.GetBaseActorValue("Magicka") - 100) / 1000
	
	if PlayerRef.GetSitState() >= 3
		mult += 0.05
	endif
	;Check if player is in the College of Winterhold
	if PlayerRef.IsInLocation(WinterholdCollegeLocation)
		mult += 0.10
	endIf
	;Check if player is in the Arcanaeum
	if PlayerRef.IsInLocation(WinterholdCollegeArcanaeumLocation)
		mult += 0.15
	endIf
	;Check if player is in an inn
	if PlayerRef.GetCurrentLocation().HasKeyword(LocTypeInn)
		mult += 0.05
	endIf
	;Check if player is in an owned home
	if PlayerRef.GetCurrentLocation().HasKeyword(LocTypePlayerHouse)
		mult += 0.10
	endIf
	;Check if player is Rested or Well Rested
	if PlayerRef.HasMagicEffect(RestedSkillEffect)
		mult += 0.05
	elseif PlayerRef.HasMagicEffect(RestedWellSkillEffect)
		mult += 0.10
	endIf
	
	return mult
endfunction

int function getHoursToStudy(globalvariable gv_hours, bool isNewStudy = true)
	int hoursToStudy = 0
		if gv_hours.getValue() > 1440
			if FPerson.GetValue()
				hoursToStudy = FPStudyMonthsMessage.Show()
			else
				hoursToStudy = StudyMonthsMessage.Show()
			endif
		elseif gv_hours.getValue() > 48
			if FPerson.GetValue()
				hoursToStudy = FPStudyDaysMessage.Show( Round(gv_hours.getValue() / 24) )
			else
				hoursToStudy = StudyDaysMessage.Show( Round(gv_hours.getValue() / 24) )
			endif
		elseif isNewStudy
			if FPerson.GetValue()
				hoursToStudy = FPStudyStartMessage.Show(gv_hours.getValue())
			else
				hoursToStudy = StudyStartMessage.Show(gv_hours.getValue())
			endif
		else
			if FPerson.GetValue()
				hoursToStudy = FPStudyContinueMessage.Show(hoursStudiedTotal.getValue(), gv_hours.getValue())
			else
				hoursToStudy = StudyContinueMessage.Show(hoursStudiedTotal.getValue(), gv_hours.getValue())
			endif
		endif
	return hoursToStudy
endfunction
