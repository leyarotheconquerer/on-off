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

	void HandleMouseButtonDown(StringHash type, VariantMap& data)
	{
		if (data["Button"] == MOUSEB_LEFT)
		{
			if (Power > 0)
			{
				IsPowered = !IsPowered;

				VariantMap data;
				if (IsPowered)
				{
					data["Power"] = Power;
					SendEvent("PowerActivated", data);
				}
				else
				{
					data["Power"] = Power;
					SendEvent("PowerDeactivated", data);
				}
			}
		}
	}
}
