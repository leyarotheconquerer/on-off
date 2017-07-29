shared class Player: ScriptObject
{
	float pitch_;
	float yaw_;
	Node@ cameraMount_;

	Player()
	{
		pitch_ = 0.0f;
		yaw_ = 0.0f;
	}

	void Start()
	{
		SubscribeToEvent("KeyDown", "HandleKeyDown");
	}

	void DelayedStart()
	{
		cameraMount_ = node.GetChild("CameraMount", true);
	}

	void Update(float timestep)
	{
		const float MOUSE_SENSITIVITY = 0.1f;

		IntVector2 mouseMove = input.mouseMove;
		yaw_ += MOUSE_SENSITIVITY * mouseMove.x;
		pitch_ += MOUSE_SENSITIVITY * mouseMove.y;
		pitch_ = Clamp(pitch_, -15.0f, 15.0f);

		cameraMount_.rotation = Quaternion(pitch_, yaw_, 0.0f);
	}

	void Stop()
	{
	}

	void HandleKeyDown(StringHash type, VariantMap& data)
	{
		if (data["Key"] == KEY_ESCAPE)
		{
			engine.Exit();
		}
	}
}
