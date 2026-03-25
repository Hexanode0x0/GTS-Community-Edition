;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 28
Scriptname QF_IG88_DDQuest_05005900 Extends Quest Hidden

;BEGIN ALIAS PROPERTY TeleportWildernessDestination
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TeleportWildernessDestination Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Key
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Key Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY XMarkerCageFront
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_XMarkerCageFront Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY XMarkerWalkAway
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_XMarkerWalkAway Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY TeleportDestination
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TeleportDestination Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerGearChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerGearChest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Androsseus
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Androsseus Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SFX_Heartbeat
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SFX_Heartbeat Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY KnockoutTrigger
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_KnockoutTrigger Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY XMarkerPlayerCageGate
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_XMarkerPlayerCageGate Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Letter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Letter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SFX_Unconscious
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SFX_Unconscious Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CageCollision
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CageCollision Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY XMarkerHallway
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_XMarkerHallway Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SFX_Knockout
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SFX_Knockout Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CageDoor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CageDoor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY XMarkerHesitate
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_XMarkerHesitate Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WaitingRoom
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WaitingRoom Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
; ----- This stage is reached by interacting with the cage door. See script attached to alias CageDoor --------
; Move player to waiting room.
Game.GetPlayer().MoveTo(Alias_WaitingRoom.GetRef())

; Player did not kill self. Complete objective.
SetObjectiveCompleted(30)

; Take controls away from player again
Game.ForceFirstPerson()
Game.DisablePlayerControls(true, true, true, false, true, false, true, false)

; Enable creepy heartbeat SFX
Alias_SFX_Heartbeat.GetRef().Enable()

; Fade screen to black
pBlackScreenIMOD.Apply()

; ======= Time jump and vampirism======; ------ RP messages ----------------
;Utility.Wait(1)
;Debug.MessageBox("The shame of it overwhelms you. You want to end it, but you just can't. You are too weak.")
;Utility.Wait(6)
;Debug.MessageBox("Days pass. Another vampire brings you water every now and then. One time, her eyes linger hungrily on your throat as she throws a roasted mouse at your feet.")
;Utility.Wait(6)
;Debug.MessageBox("The thirst is unbearable. You greedily swallow every ounce of water offered to you. You ask for more. Laughing, the other vampire grants your request. But your thirst will not be quenched. You want more... Is it blood you crave? No... Not yet, at least.")
; --------------------------------------------

Utility.Wait(1)

; GTS CE: force third person to prevent race change bug
Game.ForceThirdPerson()
Utility.Wait(1)

; Turn the player into a vampire
PlayerVampireQuest.VampireChange(Game.GetPlayer())

; GTS CE: back to first now
Utility.Wait(1)
Game.ForceFirstPerson()

; Set game hour to a bit past midnight
pGameHour.SetValue(0.1)

; =================================

; Re-enable player controls to allow for vampire transformation
; Game.EnablePlayerControls(abMenu = False)

Utility.Wait(4)

; Wait a bit for the black screen to take effect, then play the knockdown idle,
; 		which ensures that the player is lying down when they wake up.
; Game.ForceFirstPerson()
; Game.DisablePlayerControls(true, true, true, false, true, false, true, false)

; Disable Androsseus (captor)
Alias_Androsseus.GetActorRef().Disable()

; Advance to next stage
SetStage(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Make the player walk to cage door.
Game.ForceFirstPerson()
Game.DisablePlayerControls(true, true, true, false, true, false, true, false)
Game.SetPlayerAIDriven(true)

; Disable collision plane so player can walk to cage door
Alias_CageCollision.GetRef().Disable()

; Start scene.
Alias_Androsseus.GetActorRef().Enable()
IG88_DDAndrosseusEnter.Start()
Debug.MessageBox("You hear footsteps nearby. Suddenly alert, you walk to the cage door.")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
; In this stage, the player is transported to the wilderness.

; Clean up: remove drain magicka disease
Game.GetPlayer().RemoveSpell(pIG88_DrainMagickaDisease)

; Move player to wilderness marker
Game.GetPlayer().MoveTo(Alias_TeleportWildernessDestination.GetRef())
Game.GetPlayer().PlayIdle(pKnockoutIdle)
Utility.Wait(4)

; RP message
Debug.MessageBox("A sharp pain pierces your stomach, awakening you. Never have you felt so thirsty.")

; Player wake up sequence
pWakeUpIMOD.Apply()
pBlackScreenIMOD.Remove()
Utility.Wait(4)
Game.GetPlayer().PlayIdle(pGetUpIdle)

Utility.Wait(7)

; Enable player controls again
Game.EnablePlayerControls()

; Narration and notify player of letter
Debug.MessageBox("As you get your bearing, you notice a piece of paper in your robe's pocket.")
Utility.Wait(1.5)

; Add letter to player
Game.GetPlayer().AddItem(Alias_Letter.GetRef())

; Re-enable followers
IG88_DDFollowerDisableQuest.SetStage(10)

; Update objective
SetObjectiveDisplayed(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN CODE
; Player has read letter.

; Add key to player's inventory
SetObjectiveCompleted(50)
Game.GetPlayer().AddItem(Alias_Key.GetRef())

; Start up misc quest to get gear
pIG88_DDQuestMiscGear.Start()

; Clean up - player no longer essential
Game.GetPlayer().GetActorBase().SetEssential(False)

; Clean up - remove IMODs
pWakeUpIMOD.Remove()

; Proceed to shutdown stage
SetStage(200)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN CODE
; ---- Shutdown stage ---------------
CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN CODE
; Player tried to kill self. Give RP message, then proceed as if player did nothing.

Debug.Messagebox("You find a small, sharp piece of bone in one of the corners of the cage. You hesitate at first, dreading what will follow. Then, you slit your wrist wide open. Blood pours out, and you feel yourself ebbing away.")
SetStage(40)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_22
Function Fragment_22()
;BEGIN CODE
; Androsseus force greet stage
Alias_Androsseus.GetActorRef().EvaluatePackage()
Game.SetPlayerAIDriven(False)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; Scene has ended. Re-enable player controls.
SetObjectiveCompleted(15)
SetObjectiveDisplayed(30)
Game.EnablePlayerControls()

; Autosave
Game.RequestAutoSave()

; On player activating the cage door, a script will run. This will advance the quest to the next stage.
; See script attached to alias CageDoor.
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Alias_KnockoutTrigger.GetRef().Enable()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_26
Function Fragment_26()
;BEGIN CODE
; Scene where Androsseus leaves.
; He will no longer force greet player

IG88_AndrosseusLeave.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
; ------- Player is now in cage ---------

; Clean up: Disable knockout SFXs
Alias_SFX_Knockout.GetRef().Disable()
Alias_SFX_Unconscious.GetRef().Disable()

; Put clothes on player
Game.GetPlayer().EquipItem(pClothesRobesBlack, abSilent = True)
Game.GetPlayer().EquipItem(pClothesNecromancerBoots, abSilent = True)

; Enable collision plane so player can't walk to cage door
Alias_CageCollision.GetRef().Enable()

; Hard save before conversation
Game.RequestSave()

; Give player control back (temporarily), update objective
Game.EnablePlayerControls()
SetObjectiveDisplayed(15)

Utility.Wait(10)
SetStage(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Player has entered trigger. Infect with vampirism, then disable trigger.
; Game.GetPlayer().AddSpell(pContractVampirism, False) ; Changed V 1.1: DO NOT INFECT WITH VAMPIRISM, USE VANILLA TURN VAMPIRISM SCRIPT IN LATER STAGE
Game.GetPlayer().AddSpell(pIG88_DrainMagickaDisease, False)
Alias_KnockoutTrigger.GetRef().Disable()
Alias_SFX_Knockout.GetRef().Enable()
Alias_SFX_Unconscious.GetRef().Enable()

; Force first person and disable player controls (except looking)
Game.ForceFirstPerson()
Game.DisablePlayerControls(true, true, true, false, true, false, true, false)

; Start the quest that disables followers
IG88_DDFollowerDisableQuest.Start()

; Pull player out of werewolf form if active
if (PlayerWerewolfQuest.IsRunning())
	(PlayerWerewolfQuest as PlayerWerewolfChangeScript).ShiftBack()
endif

; Play knockdown idle and IMOD
Game.GetPlayer().PlayIdle(pKnockoutIdle)
pStrikeandFallIMOD.Apply()
Utility.Wait(6.5)
pBlackScreenIMOD.Apply()
Utility.Wait(1)
pStrikeandFallIMOD.Remove()

; Remove player's items, store in chest
Game.GetPlayer().RemoveAllItems(akTransferTo = Alias_PlayerGearChest.GetRef(), abKeepOwnership = True)

; Teleport player to destination
Game.GetPlayer().MoveTo(Alias_TeleportDestination.GetRef())

; Player wake up IMODs
pWakeUpIMOD.Apply()
Utility.Wait(1)
pBlackScreenIMOD.Remove()
Game.GetPlayer().PlayIdle(pGetUpIdle)

Utility.Wait(8)
SetStage(15)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property pIG88_DDQuestScene  Auto  

Message Property pIG88_PostSceneChoiceMessage  Auto  

SPELL Property pContractVampirism  Auto  

GlobalVariable Property pTimescale  Auto  

Idle Property pKnockoutIdle  Auto  

ImageSpaceModifier Property pStrikeandFallIMOD  Auto  

ImageSpaceModifier Property pBlackScreenIMOD  Auto  

Idle Property pGetUpIdle  Auto  

ImageSpaceModifier Property pWakeUpIMOD  Auto  

Container Property pIG88Chest  Auto  

GlobalVariable Property pGameHour  Auto  

Quest Property pIG88_DDQuestMiscGear  Auto  

Armor Property pClothesRobesBlack  Auto  

Armor Property pClothesNecromancerBoots  Auto  

SPELL Property pIG88_DrainMagickaDisease  Auto  

GlobalVariable Property pGameDay  Auto  

PlayerVampireQuestScript Property PlayerVampireQuest auto

Quest Property IG88_DDFollowerDisableQuest  Auto  

Quest Property PlayerWerewolfQuest  Auto  

Scene Property IG88_DDAndrosseusEnter  Auto  

Scene Property IG88_AndrosseusLeave  Auto  
