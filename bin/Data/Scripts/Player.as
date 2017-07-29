shared class Player: ScriptObject
{
	float pitch_;
	float yaw_;
	Node@ cameraMount_;

	Vector3 debugDirection_;

	Player()
	{
		pitch_ = 0.0f;
		yaw_ = 0.0f;
	}

	void Start()
	{
		SubscribeToEvent("KeyDown", "HandleKeyDown");
		SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
	}

	void DelayedStart()
	{
		cameraMount_ = node.GetChild("CameraMount", true);
	}

	void Update(float timestep)
	{
		const float MOVEMENT_STRENGTH = 20.0f;
		const float MOUSE_SENSITIVITY = 0.1f;

		IntVector2 mouseMove = input.mouseMove;
		yaw_ += MOUSE_SENSITIVITY * mouseMove.x;
		pitch_ += MOUSE_SENSITIVITY * mouseMove.y;
		pitch_ = Clamp(pitch_, -15.0f, 15.0f);
		cameraMount_.rotation = Quaternion(pitch_, yaw_, 0.0f);

		Vector3 direction = Vector3::ZERO;
		if (input.keyDown[KEY_W] || input.keyDown[KEY_UP])
		{
			direction += Vector3::FORWARD;
		}
		if (input.keyDown[KEY_S] || input.keyDown[KEY_DOWN])
		{
			direction += Vector3::BACK;
		}
		if (input.keyDown[KEY_A] || input.keyDown[KEY_LEFT])
		{
			direction += Vector3::LEFT;
		}
		if (input.keyDown[KEY_D] || input.keyDown[KEY_RIGHT])
		{
			direction += Vector3::RIGHT;
		}

		if (direction != Vector3::ZERO)
		{
			Quaternion dirRotation = Quaternion(0.0f, yaw_, 0.0f);
			direction = dirRotation * direction;
			debugDirection_ = direction;
			direction *= MOVEMENT_STRENGTH;

			RigidBody@ rigidBody = node.GetComponent("RigidBody");
			rigidBody.ApplyForce(direction);
		}

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

	void HandlePostRenderUpdate(StringHash type, VariantMap& data)
	{
		if (input.keyDown[KEY_P])
		{
			DebugRenderer@ debugRenderer = node.scene.GetComponent("DebugRenderer");
			PhysicsWorld@ world = node.scene.GetComponent("PhysicsWorld");

			Vector3 origin = node.position + Vector3::UP;
			Vector3 target = node.position + debugDirection_ * 2 + Vector3::UP;

			debugRenderer.AddLine(origin, target, Color(1.0, 0, 0));
			world.DrawDebugGeometry(debugRenderer, true);
		}
	}
}
