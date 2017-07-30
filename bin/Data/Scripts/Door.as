class Door: ScriptObject
{
	float VerticalDraw;
	float DrawRate;

	private bool isPowered_;
	private Node@ doorNode_;
	private Vector3 doorOrigin_;

	Door()
	{
		VerticalDraw = 5;
		DrawRate = 1;
	}

	void Start()
	{
		isPowered_ = false;
	}

	void DelayedStart()
	{
		doorNode_ = node.GetChild("Door");
		doorOrigin_ = doorNode_.position;

		SubscribeToEvent("PowerActivated", "HandlePowerActivated");
		SubscribeToEvent("PowerDeactivated", "HandlePowerDeactivated");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteFloat(VerticalDraw);
		serializer.WriteFloat(DrawRate);
	}

	void Load(Deserializer& deserializer)
	{
		VerticalDraw = deserializer.ReadFloat();
		DrawRate = deserializer.ReadFloat();
	}

	void Update(float timestep)
	{
		if (isPowered_)
		{
			if (doorNode_.position.y < doorOrigin_.y + VerticalDraw)
			{
				doorNode_.position = doorNode_.position.Lerp(doorOrigin_ + Vector3::UP * VerticalDraw, timestep / DrawRate);
			}
		}
		else
		{
			RigidBody@ rigidBody = doorNode_.GetComponent("RigidBody");
			if (doorNode_.position.y > doorOrigin_.y)
			{
				rigidBody.kinematic = false;
			}
			else
			{
				rigidBody.kinematic = true;
			}
		}
	}

	void Stop()
	{
	}

	void HandlePowerActivated(StringHash type, VariantMap& data)
	{
		isPowered_ = true;
	}

	void HandlePowerDeactivated(StringHash type, VariantMap& data)
	{
		isPowered_ = false;
	}
}
