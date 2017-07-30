class MainMenu: ScriptObject
{
	String NextLevel;
	String MenuUI;

	private UIElement@ mainMenu_;

	MainMenu()
	{
		NextLevel = "";
		MenuUI = "";
	}

	void Start()
	{
		input.SetMouseVisible(true);
		SubscribeToEvent("KeyDown", "HandleKeyDown");
	}

	void DelayedStart()
	{
		log.Debug("Loading: " + MenuUI);
		mainMenu_ = ui.root.LoadChildXML(cache.GetResource("XMLFile", MenuUI));
		UIElement@ playButton = ui.root.GetChild("Play", true);
		UIElement@ exitButton = ui.root.GetChild("Exit", true);
		SubscribeToEvent(playButton, "Pressed", "HandlePlayPressed");
		SubscribeToEvent(exitButton, "Pressed", "HandleExitPressed");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(NextLevel);
		serializer.WriteString(MenuUI);
	}

	void Load(Deserializer& deserializer)
	{
		NextLevel = deserializer.ReadString();
		MenuUI = deserializer.ReadString();
	}

	void Stop()
	{
		ui.root.RemoveChild(mainMenu_);
		input.SetMouseVisible(false);
	}

	void HandlePlayPressed(StringHash type, VariantMap& data)
	{
		VariantMap sendData;
		sendData["NextLevel"] = NextLevel;
		sendData["DisplayMessage"] = false;
		SendEvent("LevelComplete", sendData);
	}

	void HandleExitPressed(StringHash type, VariantMap& data)
	{
		engine.Exit();
	}

	void HandleKeyDown(StringHash type, VariantMap& data)
	{
		if (data["Key"] == KEY_ESCAPE)
		{
			engine.Exit();
		}
	}
}
