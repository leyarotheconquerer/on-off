shared class Pickup: ScriptObject
{
	float Power;
	float RotationRate;
	float OscillationRate;
	float VerticalRange;
	String Type;

	private float yaw_;
	private float elapsed_;
	private Quaternion modelRotation_;
	private Node@ modelNode_;
	private Vector3 originalPosition_;

	Pickup()
	{
		RotationRate = 2;
		OscillationRate = 2;
		VerticalRange = .5;
		elapsed_;
	}

	void Start()
	{
		yaw_ = node.rotation.yaw;
		SubscribeToEvent(node, "NodeCollisionStart", "HandleNodeCollisionStart");
		SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
	}

	void DelayedStart()
	{
		modelNode_ = node.GetChild("Model");
		modelRotation_ = modelNode_.rotation;
		originalPosition_ = node.position;
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteFloat(Power);
		serializer.WriteFloat(RotationRate);
		serializer.WriteFloat(OscillationRate);
		serializer.WriteFloat(VerticalRange);
		serializer.WriteString(Type);
	}

	void Load(Deserializer& deserializer)
	{
		Power = deserializer.ReadFloat();
		RotationRate = deserializer.ReadFloat();
		OscillationRate = deserializer.ReadFloat();
		VerticalRange = deserializer.ReadFloat();
		Type = deserializer.ReadString();
	}

	void Update(float timestep)
	{
		if (RotationRate > 0)
		{
			yaw_ += timestep * 360 / RotationRate;
			Quaternion newRotation = Quaternion(0.0f, yaw_, 0.0f) * modelRotation_;
			modelNode_.rotation = newRotation;

			elapsed_ += timestep;
			if (elapsed_ > 4 * M_PI)
			{
				elapsed_ = 0;
			}
			Vector3 newPosition = originalPosition_ + Vector3::UP * Sin((elapsed_ * 360 / M_PI) / OscillationRate) * VerticalRange;
			node.position = node.position.Lerp(newPosition, .1);
		}
	}

	void Stop()
	{
	}

	void HandleNodeCollisionStart(StringHash type, VariantMap& data)
	{
		Node@ other = data["OtherNode"].GetPtr();
		if (other.HasTag("pickuper"))
		{
			VariantMap sendData;
			sendData["PickupNode"] = node;
			sendData["PickuperNode"] = other;
			sendData["Type"] = Type;
			sendData["Power"] = Power;
			other.SendEvent("Pickup", sendData);

			node.Remove();
		}
	}

	void HandlePostRenderUpdate(StringHash type, VariantMap& data)
	{
		if (input.keyDown[KEY_P] && node.HasTag("debug"))
		{
			DebugRenderer@ debugRenderer = node.scene.GetComponent("DebugRenderer");
			Vector3 origin = node.position;
			Vector3 direction = node.position + (modelNode_.rotation * Vector3::FORWARD) * 5;
			debugRenderer.AddLine(origin, direction, Color(1, 0, 0));
		}
	}
}
