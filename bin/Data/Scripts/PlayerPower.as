shared class PlayerPower: ScriptObject
{
	float DrainRate;
	float InitialPower;
	bool IsPowered;
	float Power;
	String HUD;
	String HUDName;
	String PowerBar;
	String PowerText;

	private UIElement@ hud_;
	private UIElement@ powerBar_;
	private Text@ powerText_;
	private float maxPower_;
	private int powerBarWidth_;

	PlayerPower()
	{
		IsPowered = false;
		DrainRate = 1;
		InitialPower = 3;

		HUD = "UI/PowerHUD.xml";
		HUDName = "PowerPanel";
		PowerBar = "PowerBar";
		PowerText = "PowerText";
	}

	void Start()
	{
		ui.root.LoadChildXML(cache.GetResource("XMLFile", HUD));

		SubscribeToEvent("MouseButtonDown", "HandleMouseButtonDown");
		SubscribeToEvent(node, "Pickup", "HandlePickup");
	}

	void DelayedStart()
	{
		Power = InitialPower;
		maxPower_ = Power;

		hud_ = ui.root.GetChild(HUDName);
		powerBar_ = hud_.GetChild(PowerBar);
		powerText_ = hud_.GetChild(PowerText);
		powerBarWidth_ = hud_.width;
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteFloat(DrainRate);
		serializer.WriteFloat(InitialPower);
		serializer.WriteString(HUD);
		serializer.WriteString(HUDName);
		serializer.WriteString(PowerBar);
		serializer.WriteString(PowerText);
	}

	void Load(Deserializer& deserializer)
	{
		DrainRate = deserializer.ReadFloat();
		InitialPower = deserializer.ReadFloat();
		HUD = deserializer.ReadString();
		HUDName = deserializer.ReadString();
		PowerBar = deserializer.ReadString();
		PowerText = deserializer.ReadString();
	}

	void Update(float timestep)
	{
		float percentPower = Power / maxPower_;
		powerBar_.width = percentPower * powerBarWidth_;
		powerText_.text = "Power: " + Ceil(Power) + " / " + Ceil(maxPower_);
		if (IsPowered)
		{
			if (Power < timestep * DrainRate)
			{
				Power = 0;
				IsPowered = false;
				VariantMap data;
				data["Power"] = Power;
				SendEvent("PowerDeactivated", data);
			}
			else
			{
				Power -= timestep * DrainRate;
			}
		}
	}

	void Stop()
	{
		ui.root.RemoveChild(hud_);
	}

	void HandlePickup(StringHash type, VariantMap& data)
	{
		String pickupType = data["Type"].GetString();
		if (pickupType == "Power")
		{
			float power = data["Power"].GetFloat();
			Power += power;
			maxPower_ += power;
			log.Debug("Picked up some power: " + power);
		}
	}

	void HandleMouseButtonDown(StringHash type, VariantMap& data)
	{
		if (data["Button"] == MOUSEB_LEFT)
		{
			if (Power > 0)
			{
				IsPowered = !IsPowered;

				VariantMap sendData;
				if (IsPowered)
				{
					sendData["Power"] = Power;
					SendEvent("PowerActivated", sendData);
				}
				else
				{
					sendData["Power"] = Power;
					SendEvent("PowerDeactivated", sendData);
				}
			}
		}
	}
}
