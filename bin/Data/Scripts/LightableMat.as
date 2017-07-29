class LightableMat: ScriptObject
{
	String InactiveMat;
	String ActiveMat;

	private Node@ modelNode_;

	void Start()
	{
		SubscribeToEvent("PowerActivated", "HandlePowerActivated");
		SubscribeToEvent("PowerDeactivated", "HandlePowerDeactivated");
	}

	void DelayedStart()
	{
		modelNode_ = node.GetChild("Model");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(InactiveMat);
		serializer.WriteString(ActiveMat);
	}

	void Load(Deserializer& deserializer)
	{
		InactiveMat = deserializer.ReadString();
		ActiveMat = deserializer.ReadString();
	}

	void Stop()
	{
	}

	void HandlePowerActivated(StringHash type, VariantMap& data)
	{
		StaticModel@ model = modelNode_.GetComponent("StaticModel");
		Material@ material = cache.GetResource("Material", ActiveMat);
		model.material = material;
	}

	void HandlePowerDeactivated(StringHash type, VariantMap& data)
	{
		StaticModel@ model = modelNode_.GetComponent("StaticModel");
		Material@ material = cache.GetResource("Material", InactiveMat);
		model.material = material;
	}
}
