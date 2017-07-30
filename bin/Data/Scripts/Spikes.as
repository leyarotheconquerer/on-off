class Spikes: ScriptObject
{
	float RetractDepth;
	float RetractRate;
	float SpikeRate;
	String DeathMessage;

	private bool isPowered_;
	private bool detecting_;
	private Vector3 origin_;
	private Node@ spikesNode_;

	Spikes()
	{
		RetractDepth = 1;
		RetractRate = 1;
		SpikeRate = .2;
		DeathMessage = "Ouch! That was spikey";
	}

	void Start()
	{
		isPowered_ = false;
		detecting_ = false;

		SubscribeToEvent("PowerActivated", "HandlePowerActivated");
		SubscribeToEvent("PowerDeactivated", "HandlePowerDeactivated");
	}

	void DelayedStart()
	{
		spikesNode_ = node.GetChild("Spikes");
		origin_ = spikesNode_.position;

		Node@ detectionNode = spikesNode_.GetChild("Detection", true);
		SubscribeToEvent(detectionNode, "NodeCollisionStart", "HandleNodeCollisionStart");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteFloat(RetractDepth);
		serializer.WriteFloat(RetractRate);
		serializer.WriteFloat(SpikeRate);
		serializer.WriteString(DeathMessage);
	}

	void Load(Deserializer& deserializer)
	{
		RetractDepth = deserializer.ReadFloat();
		RetractRate = deserializer.ReadFloat();
		SpikeRate = deserializer.ReadFloat();
		DeathMessage = deserializer.ReadString();
	}

	void Update(float timestep)
	{
		if (isPowered_ && spikesNode_.position.y > origin_.y - RetractDepth)
		{
			Vector3 target = origin_ - Vector3::UP * RetractDepth;
			spikesNode_.position = spikesNode_.position.Lerp(target, timestep / RetractRate);
			detecting_ = false;
		}
		else if(!isPowered_ && spikesNode_.position.y < origin_.y)
		{
			detecting_ = true;
			spikesNode_.position = spikesNode_.position.Lerp(origin_, timestep / SpikeRate);
		}
		else
		{
			detecting_ = false;
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

	void HandleNodeCollisionStart(StringHash type, VariantMap& data)
	{
		Node@ other = data["OtherNode"].GetPtr();
		if (detecting_ && other.HasTag("player"))
		{
			VariantMap sendData;
			sendData["Type"] = "Spikes";
			sendData["DisplayMessage"] = true;
			sendData["Message"] = DeathMessage;
			SendEvent("PlayerDeath", sendData);
		}
	}
}
