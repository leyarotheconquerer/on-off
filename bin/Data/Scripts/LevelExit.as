class LevelExit: ScriptObject
{
	String NextLevel;
	String NextLevelTitle;

	private bool isActive_;
	private bool isComplete_;
	private RigidBody@ rigidBody_;

	LevelExit()
	{
		isActive_ = false;
		isComplete_ = false;
	}

	void Start()
	{
		SubscribeToEvent("PowerActivated", "HandlePowerActivated");
		SubscribeToEvent("PowerDeactivated", "HandlePowerDeactivated");
	}

	void DelayedStart()
	{
		rigidBody_ = node.GetComponent("RigidBody");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(NextLevel);
		serializer.WriteString(NextLevelTitle);
	}

	void Load(Deserializer& deserializer)
	{
		NextLevel = deserializer.ReadString();
		NextLevelTitle = deserializer.ReadString();
	}

	void Stop()
	{
	}

	void FixedUpdate(float timestep)
	{
		if (isActive_ && !isComplete_)
		{
			for (int i = 0; i < rigidBody_.collidingBodies.length; i++)
			{
				if (rigidBody_.collidingBodies[i].node.HasTag("player"))
				{
					VariantMap sendData;
					sendData["NextLevel"] = NextLevel;
					sendData["NextLevelTitle"] = NextLevelTitle;
					sendData["DisplayMessage"] = true;
					SendEvent("LevelComplete", sendData);
					isComplete_ = true;
				}
			}
		}
	}

	void HandlePowerActivated(StringHash type, VariantMap& data)
	{
		isActive_ = true;
	}

	void HandlePowerDeactivated(StringHash type, VariantMap& data)
	{
		isActive_ = false;
	}
}
