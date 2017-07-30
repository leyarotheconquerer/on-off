class DialogRegion: ScriptObject
{
	String DialogUI;
	String Tag;

	private UIElement@ dialog_;

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
		serializer.WriteString(DialogUI);
		serializer.WriteString(Tag);
	}

	void Load(Deserializer& deserializer)
	{
		DialogUI = deserializer.ReadString();
		Tag = deserializer.ReadString();
	}

	void Stop()
	{
	}

	void HandleMouseButtonDown(StringHash type, VariantMap& data)
	{
		if (data["Button"] == MOUSEB_RIGHT)
		{
			ui.root.RemoveChild(dialog_);
			node.Remove();
		}
	}

	void HandleNodeCollisionStart(StringHash type, VariantMap& data)
	{
		Node@ other = data["OtherNode"].GetPtr();
		if (other.HasTag(Tag))
		{
			UnsubscribeFromEvent(node, "NodeCollisionStart");
			dialog_ = ui.root.LoadChildXML(cache.GetResource("XMLFile", DialogUI));
			SubscribeToEvent("MouseButtonDown", "HandleMouseButtonDown");
		}
	}
}
