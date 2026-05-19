Scriptname NecroLichTrackingQuest extends Quest Conditional

Quest Property NecroLichRitualQuest auto
Quest Property MQ101 auto

int Property InTrigger  Auto  Conditional

;//////////////////////////////////////////////////////////////////////////////////////////////////////;
int Property Skin auto Conditional
; Property to determine the players skin and appearance
; 0 red flesh with crown
; 1 red flesh with hood
; 2 red skeletal with crown
; 3 red skeletal with hood
; 4 green flesh with crown
; 5 green flesh with hood
; 6 green skeletal with crown
; 7 green skeletal with hood
; 8 black flesh with crown
; 9 black flesh with hood
; 10 black skeletal with crown
; 11 black skeletal with hood

int property Shroud auto Conditional
; 0 none
; 1 red
; 2 green
; 3 black

bool Property Flesh auto

;///////////////////////////////////////////////////////////////////////////////////////////////////;

bool property HasPhylactery auto
bool property HasElixir auto
bool property HasUpgrade auto

Spell Property NecroLichTransformationRitual auto

Race Property PlayerOriginalRace auto
Race Property LichRace Auto

FormList Property CrimeFactions auto

Faction Property LichFaction auto
Faction Property HunterFaction auto

Armor Property NecroLichForm auto
Potion Property NecroLichTransformationRitualPotion auto
Book Property NecroSewerLaboratoryUpgrade auto
Book Property NecroTowerLaboratoryUpgrade auto
MiscObject Property NecroLichPhylactery  Auto

Race Property ArgonianRace auto
Race Property ArgonianRaceVampire auto
Race Property BretonRace auto
Race Property BretonRaceVampire auto
Race Property DarkElfRace auto
Race Property DarkElfRaceVampire auto
Race Property HighElfRace auto
Race Property HighElfRaceVampire auto
Race Property ImperialRace auto
Race Property ImperialRaceVampire auto
Race Property KhajiitRace auto
Race Property KhajiitRaceVampire auto
Race Property NordRace auto
Race Property NordRaceVampire auto
Race Property OrcRace auto
Race Property OrcRaceVampire auto
Race Property RedguardRace auto
Race Property RedguardRaceVampire auto
Race Property WoodElfRace auto
Race Property WoodElfRaceVampire auto

MagicEffect Property NecroRevertEffect auto
Spell Property AbLichNecroPassive auto

Perk Property Lightfoot Auto

Bool Property DLC1HasLightfoot auto

int doOnce = 0


Function GetPlayerOriginalRace()

; get player's race at the start of the first ritual transformation so we have it permanently for Lich switch back
	PlayerOriginalRace = Game.GetPlayer().GetRace()
 	;Debug.notification("LICH: Storing player's race as " + PlayerOriginalRace)

;------------------------------
; GTS CE - Race Compatibility
;------------------------------

	Race OriginalRace = RaceCompatibility.GetRaceByVampireRace(PlayerOriginalRace)
	If (OriginalRace != None)
		PlayerOriginalRace = OriginalRace
	EndIf

;	if     (PlayerOriginalRace == ArgonianRaceVampire)
; 		Debug.Trace("CSQ: Player was Argonian Vampire; storing as Argonian.")
;		PlayerOriginalRace = ArgonianRace
;	elseif (PlayerOriginalRace == BretonRaceVampire)
; 		Debug.Trace("CSQ: Player was Breton Vampire; storing as Breton.")
;		PlayerOriginalRace = BretonRace
;	elseif (PlayerOriginalRace == DarkElfRaceVampire)
; 		Debug.Trace("CSQ: Player was Dark Elf Vampire; storing as Dark Elf.")
;		PlayerOriginalRace = DarkElfRace
;	elseif (PlayerOriginalRace == HighElfRaceVampire)
; 		Debug.Trace("CSQ: Player was Hiegh Elf Vampire; storing as High Elf.")
;		PlayerOriginalRace = HighElfRace
;	elseif (PlayerOriginalRace == ImperialRaceVampire)
; 		Debug.Trace("CSQ: Player was Imperial Vampire; storing as Imperial.")
;		PlayerOriginalRace = ImperialRace
;	elseif (PlayerOriginalRace == KhajiitRaceVampire)
; 		Debug.Trace("CSQ: Player was Khajiit Vampire; storing as Khajiit.")
;		PlayerOriginalRace = KhajiitRace
;	elseif (PlayerOriginalRace == NordRaceVampire)
; 		Debug.Trace("CSQ: Player was Nord Vampire; storing as Nord.")
;		PlayerOriginalRace = NordRace
;	elseif (PlayerOriginalRace == OrcRaceVampire)
; 		Debug.Trace("CSQ: Player was Orc Vampire; storing as Orc.")
;		PlayerOriginalRace = OrcRace
;	elseif (PlayerOriginalRace == RedguardRaceVampire)
; 		Debug.Trace("CSQ: Player was Redguard Vampire; storing as Redguard.")
;		PlayerOriginalRace = RedguardRace
;	elseif (PlayerOriginalRace == WoodElfRaceVampire)
; 		Debug.Trace("CSQ: Player was Wood Elf Vampire; storing as Wood Elf.")
;		PlayerOriginalRace = WoodElfRace
;	endif

 	;Debug.Notification("LICH: Storing player's race as " + PlayerOriginalRace)

EndFunction




Function RunItemCheck()

	;UCL: progresses ritual quest when items are acquired

	if (Game.GetPlayer().GetItemCount(NecroSewerLaboratoryUpgrade)) >= 1 || (Game.GetPlayer().GetItemCount(NecroTowerLaboratoryUpgrade)) >= 1 && (HasUpgrade == 0)
		NecroLichRitualQuest.SetStage(20)
		HasUpgrade = 1
	endif

	if (Game.GetPlayer().GetItemCount(NecroLichPhylactery)) >= 1 && (HasPhylactery == 0)
		NecroLichRitualQuest.SetStage(30)
		HasPhylactery = 1
	endif

	if (Game.GetPlayer().GetItemCount(NecroLichTransformationRitualPotion)) >= 1 && (HasElixir == 0)
		NecroLichRitualQuest.SetStage(40)
		HasElixir = 1
	endif

	if (HasUpgrade == 1) && (HasPhylactery == 1) && (HasElixir == 1)
		NecroLichRitualQuest.SetStage(50)
	endif
	
EndFunction

;UCL: run a check specifically for the elixir of defilation so that the crafting bench can call this script.

Function RunPotionCheck()
	if (Game.GetPlayer().GetItemCount(NecroLichTransformationRitualPotion)) >= 1 && (HasElixir == 0)
		NecroLichRitualQuest.SetStage(40)
		HasElixir = 1
	endif
endFunction