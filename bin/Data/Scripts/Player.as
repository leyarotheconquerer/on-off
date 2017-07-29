shared class Player: ScriptObject
{
	float RestingFriction;
	float MovingFriction;

	float pitch_;
	float yaw_;
	Quaternion modelRotation_;
	Node@ cameraMountNode_;
	Node@ modelNode_;

	Vector3 debugDirection_;

	Player()
	{
		pitch_ = 0.0f;
		yaw_ = 0.0f;
		RestingFriction = MovingFriction = 2.0f;
	}

	void Start()
	{
		SubscribeToEvent("KeyDown", "HandleKeyDown");
		SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
	}

	void DelayedStart()
	{
		cameraMountNode_ = node.GetChild("CameraMount", true);
		modelNode_ = node.GetChild("Model", true);
		modelRotation_ = modelNode_.rotation;
	}

	void Update(float timestep)
	{
		const float MOVEMENT_STRENGTH = 20.0f;
		const float MOVEMENT_MARGIN = 0.1f;
		const float MOUSE_SENSITIVITY = 0.1f;

		IntVector2 mouseMove = input.mouseMove;
		yaw_ += MOUSE_SENSITIVITY * mouseMove.x;
		pitch_ += MOUSE_SENSITIVITY * mouseMove.y;
		pitch_ = Clamp(pitch_, -15.0f, 15.0f);
		cameraMountNode_.rotation = Quaternion(pitch_, yaw_, 0.0f);

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

		RigidBody@ rigidBody = node.GetComponent("RigidBody");
		if (direction != Vector3::ZERO)
		{
			Quaternion dirRotation = Quaternion(0.0f, yaw_, 0.0f);
			direction = dirRotation * direction;
			debugDirection_ = direction;
			direction *= MOVEMENT_STRENGTH;

			rigidBody.friction = MovingFriction;
			rigidBody.ApplyForce(direction);
		}
		else
		{
			rigidBody.friction = RestingFriction;
		}

		if (rigidBody.linearVelocity.lengthSquared > MOVEMENT_MARGIN)
		{
			Vector3 lateralVelocity = Vector3(rigidBody.linearVelocity.x, 0, rigidBody.linearVelocity.z);
			Quaternion lateralRotation;
			lateralRotation.FromLookRotation(lateralVelocity, Vector3::UP);
			lateralRotation = lateralRotation * modelRotation_;
			modelNode_.rotation = modelNode_.rotation.Nlerp(lateralRotation, 0.3, true);
		}
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteFloat(MovingFriction);
		serializer.WriteFloat(RestingFriction);
	}

	void Load(Deserializer& deserializer)
	{
		MovingFriction = deserializer.ReadFloat();
		RestingFriction = deserializer.ReadFloat();
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
			Vector3 moveTarget = origin + debugDirection_ * 2;
			Vector3 faceTarget = (modelNode_.rotation * Vector3::FORWARD) * 3 + origin;

			debugRenderer.AddLine(origin, faceTarget, Color(0, 1, 0));
			debugRenderer.AddLine(origin, moveTarget, Color(1.0, 0, 0));
			world.DrawDebugGeometry(debugRenderer, true);
		}
	}
}
