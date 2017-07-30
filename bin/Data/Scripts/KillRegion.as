class KillRegion: ScriptObject
{
	String Type;
	String Message;
	String Tag;

	KillRegion()
	{
		Type = "GenericDeath";
		Message = "You died";
		Tag = "player";
	}

	void Start()
	{
		SubscribeToEvent(node, "NodeCollisionStart", "HandleNodeCollisionStart");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(Type);
		serializer.WriteString(Message);
		serializer.WriteString(Tag);
	}

	void Load(Deserializer& deserializer)
	{
		Type = deserializer.ReadString();
		Message = deserializer.ReadString();
		Tag = deserializer.ReadString();
	}

	void HandleNodeCollisionStart(StringHash type, VariantMap& data)
	{
		Node@ other = data["OtherNode"].GetPtr();
		if (other.HasTag(Tag))
		{
			VariantMap sendData;
			sendData["Type"] = Type;
			sendData["DisplayMessage"] = true;
			sendData["Message"] = Message;
			SendEvent("PlayerDeath", sendData);
		}
	}

}
