ScriptName TrueDirectionalMovement hidden

;-- Functions ---------------------------------------

Actor Function GetCurrentTarget() Global Native

Bool Function GetDirectionalMovementState() Global Native

; Skipped compiler generated GetState

Bool Function GetTargetLockState() Global Native

; Skipped compiler generated GotoState

Function ToggleDisableDirectionalMovement(String asModName, Bool abDisable) Global Native

Function ToggleDisableHeadtracking(String asModName, Bool abDisable) Global Native

Event onBeginState()
{ Event received when this state is switched to }
  ; Empty function
EndEvent

Event onEndState()
{ Event received when this state is switched away from }
  ; Empty function
EndEvent
