class Bridge: ScriptObject
{
	String Span;
	float SpanScale;

	private Node@ bridgeSpan_;

	Bridge()
	{
		Span = "";
		SpanScale = 1;
	}

	void Start()
	{
		SubscribeToEvent("PowerActivated", "HandlePowerActivated");
		SubscribeToEvent("PowerDeactivated", "HandlePowerDeactivated");
	}

	void DelayedStart()
	{
		bridgeSpan_ = node.GetChild("BridgeSpan");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(Span);
		serializer.WriteFloat(SpanScale);
	}

	void Load(Deserializer& deserializer)
	{
		Span = deserializer.ReadString();
		SpanScale = deserializer.ReadFloat();
	}

	void Stop()
	{
	}

	void HandlePowerActivated(StringHash type, VariantMap& data)
	{
		Node@ newNode = bridgeSpan_.CreateChild("Span");
		XMLFile@ spanFile = cache.GetResource("XMLFile", Span);
		newNode.LoadXML(spanFile.root);
		newNode.scale = Vector3(newNode.scale.x, newNode.scale.y, SpanScale);
	}

	void HandlePowerDeactivated(StringHash type, VariantMap& data)
	{
		bridgeSpan_.RemoveAllChildren();
	}
}
