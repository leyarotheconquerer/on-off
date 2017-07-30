class DialogRegion: ScriptObject
{
	String Tag;
	String DialogElement;
	String Title;
	String Message;
	String Image;
	IntRect ImageRect;

	DialogRegion()
	{
	}

	void Start()
	{
	}

	void DelayedStart()
	{
		SubscribeToEvent(node, "NodeCollisionStart", "HandleNodeCollisionStart");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(Tag);
		serializer.WriteString(DialogElement);
		serializer.WriteString(Title);
		serializer.WriteString(Message);
		serializer.WriteString(Image);
		serializer.WriteIntRect(ImageRect);
	}

	void Load(Deserializer& deserializer)
	{
		Tag = deserializer.ReadString();
		DialogElement = deserializer.ReadString();
		Title = deserializer.ReadString();
		Message = deserializer.ReadString();
		Image = deserializer.ReadString();
		ImageRect = deserializer.ReadIntRect();
	}

	void Stop()
	{
	}

	void HandleNodeCollisionStart(StringHash type, VariantMap& data)
	{
		Node@ other = data["OtherNode"].GetPtr();
		if (other.HasTag(Tag))
		{
			UnsubscribeFromEvent(node, "NodeCollisionStart");
			VariantMap sendData;
			sendData["Dialog"] = DialogElement;
			sendData["Title"] = Title;
			sendData["Message"] = Message;
			sendData["Image"] = Image;
			sendData["ImageRect"] = ImageRect;
			SendEvent("ShowDialog", sendData);
			node.Remove();
		}
	}
}
