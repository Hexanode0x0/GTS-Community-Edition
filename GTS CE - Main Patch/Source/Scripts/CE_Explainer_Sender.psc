Scriptname CE_Explainer_Sender Extends ActiveMagicEffect

Event OnEffectStart(Actor __, Actor _)
	UIExtensions.InitMenu("UITextEntryMenu")
	UIExtensions.OpenMenu("UITextEntryMenu")
	string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
	if result == ""
		debug.notification("No Result")
		return
	endif
	int handle = ModEvent.Create("CE_Explainer")
	ModEvent.PushString(handle, result)
	ModEvent.Send(handle)
EndEvent
