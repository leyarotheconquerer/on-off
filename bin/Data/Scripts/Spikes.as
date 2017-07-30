class Spikes: ScriptObject
{
	float RetractDepth;
	float RetractRate;
	float SpikeRate;

	private bool isPowered_;
	private Vector3 origin_;
	private Node@ spikesNode_;

	Spikes()
	{
		RetractDepth = 1;
		RetractRate = 1;
		SpikeRate = .2;
	}

	void Start()
	{
		isPowered_ = false;

		SubscribeToEvent("PowerActivated", "HandlePowerActivated");
		SubscribeToEvent("PowerDeactivated", "HandlePowerDeactivated");
	}

	void DelayedStart()
	{
		spikesNode_ = node.GetChild("Spikes");
		origin_ = spikesNode_.position;
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteFloat(RetractDepth);
		serializer.WriteFloat(RetractRate);
		serializer.WriteFloat(SpikeRate);
	}

	void Load(Deserializer& deserializer)
	{
		RetractDepth = deserializer.ReadFloat();
		RetractRate = deserializer.ReadFloat();
		SpikeRate = deserializer.ReadFloat();
	}

	void Update(float timestep)
	{
		if (isPowered_ && spikesNode_.position.y > origin_.y - RetractDepth)
		{
			Vector3 target = origin_ - Vector3::UP * RetractDepth;
			spikesNode_.position = spikesNode_.position.Lerp(target, timestep / RetractRate);
		}
		else if(!isPowered_ && spikesNode_.position.y < origin_.y)
		{
			spikesNode_.position = spikesNode_.position.Lerp(origin_, timestep / SpikeRate);
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
