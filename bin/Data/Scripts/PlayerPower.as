shared class PlayerPower: ScriptObject
{
	float DrainRate;
	float InitialPower;
	bool IsPowered;
	float Power;

	PlayerPower()
	{
		IsPowered = false;
		DrainRate = 1;
		InitialPower = 3;
	}

	void Start()
	{
		SubscribeToEvent("MouseButtonDown", "HandleMouseButtonDown");
		SubscribeToEvent(node, "Pickup", "HandlePickup");
	}

	void DelayedStart()
	{
		Power = InitialPower;
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteFloat(DrainRate);
		serializer.WriteFloat(InitialPower);
	}

	void Load(Deserializer& deserializer)
	{
		DrainRate = deserializer.ReadFloat();
		InitialPower = deserializer.ReadFloat();
	}

	void Update(float timestep)
	{
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
	}

	void HandlePickup(StringHash type, VariantMap& data)
	{
		String pickupType = data["Type"].GetString();
		if (pickupType == "Power")
		{
			float power = data["Power"].GetFloat();
			Power += power;
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
