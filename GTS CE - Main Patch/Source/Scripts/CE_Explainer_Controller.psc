Scriptname CE_Explainer_Controller Extends Quest

import SkyPrompt

Actor Property PlayerREF Auto
Perk Property AllowExplainer Auto

; General Design:
; Explainers come from an external script via a mod event. Once an explainer is added to the queue, OnUpdate will try to show it
; The queue and show function is not responsible for checking if an explainer has already been shown. This is up to the sending code
; The sender will recieve a callback mod event with their string as ID and a bool indicating whether the player accepted the prompt

string[] queue
int queueNextFree
bool isPromptShown = false
int clientID
bool processing = false

Function GenerateClientID()
	clientID = RegisterForSkyPromptEvent(self as Form)
	if clientID == 0
		debug.MessageBox("SkyPrompt not detected. Make sure CE is fully installed and enabled.")
	else
		RequestTheme(clientID, "CE_Explainer_SkyPrompt")
		RegisterForModEvent("CE_Explainer", "OnExplainerRecieved")
	endif
EndFunction

Event OnInit()
	if queueNextFree == 0
		queue = new string[50]
		queueNextFree = 0
	endif
	GenerateClientID()
	RegisterForSingleUpdate(2)
EndEvent

Event OnExplainerRecieved(String promptText)
	AddToQueue(promptText)
	UnregisterForUpdate()
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	if queueNextFree <= 0
		return
	endif
	if processing
		UnregisterForUpdate()
		RegisterForSingleUpdate(1)
		return
	endif
	processing = true
	bool isOkToShowPrompt = Game.IsMovementControlsEnabled() && Game.IsActivateControlsEnabled() && Game.IsLookingControlsEnabled() && !Utility.IsInMenuMode() && PlayerREF.HasPerk(AllowExplainer)
	if isPromptShown && !isOkToShowPrompt
		;RemovePrompt(int clinetID, int eventID, int actionID)
		RemovePrompt(clientID, 0, 0)
		isPromptShown = false
		UnregisterForUpdate()
		RegisterForSingleUpdate(1)
		processing = false
		return
	endif
	
	if isOkToShowPrompt && !isPromptShown
		string promptText = queue[0] ;peek the queue, don't consume yet in case we want to remove the prompt and show later
		;SendPromptForControl(int clientID, string promptText, int eventID, int actionID, int promptType, Form refForm, string controlName, int ContextID, float progress)
		if !SendPromptForControl(clientID, promptText, 0, 0, 0, None, "Toggle POV", 0, 1.99)
			;debug.notification("Failed to send explainer SkyPrompt for: " + promptText)
			GenerateClientID()
		else
			isPromptShown = true
		endif
	endif
	UnregisterForUpdate()
	RegisterForSingleUpdate(1)
	processing = false
EndEvent

Event OnSkyPromptEvent(int clinetIDRx, int eventType, int eventID, int actionID, float deltaX, float deltaY, float progress)
	processing = true
	if !clinetIDRx == clientID
		return
	endif
	if eventType == 0
		int handle = ModEvent.Create("CE_Explainer_Callback")
		ModEvent.PushString(handle, PopQueue())
		ModEvent.PushBool(handle, true)
		ModEvent.Send(handle)
		RemovePrompt(clientID, 0, 0)
		isPromptShown = false
		UnregisterForUpdate()
		RegisterForSingleUpdate(30)
	elseif eventType == 1 || eventType == 4
		int handle = ModEvent.Create("CE_Explainer_Callback")
		ModEvent.PushString(handle, PopQueue())
		ModEvent.PushBool(handle, false)
		ModEvent.Send(handle)
		RemovePrompt(clientID, 0, 0)
		isPromptShown = false
		UnregisterForUpdate()
		RegisterForSingleUpdate(30)
	endif
	processing = false
EndEvent

Function AddToQueue(String stringToAdd)
	if queueNextFree == 49
		debug.notification("Explainer Queue Full")
		return
	endif
	queue[queueNextFree] = stringToAdd
	queueNextFree = queueNextFree + 1
EndFunction

String Function PopQueue()
	if queueNextFree == 0
		return ""
	endif
	String result = queue[0]
	int i = 0
	while i < queueNextFree - 1
		queue[i] = queue[i + 1]
		i = i + 1
	endwhile
	queueNextFree = queueNextFree - 1
	return result
EndFunction
