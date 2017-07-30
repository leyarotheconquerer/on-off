Scene@ newScene_;
Scene@ scene_;
Camera@ camera_;

void Start()
{
	StartScene("Scenes/Level1.xml");
	SubscribeToEvent("LevelComplete", "HandleLevelComplete");
}

void Stop()
{
}

void HandleLevelComplete(StringHash type, VariantMap& data)
{
	log.Debug("Level Complete. I should be loading "+data["NextLevel"].GetString());
	StartScene(data["NextLevel"].GetString());
}

void StartScene(String scene)
{
	newScene_ = Scene();
	newScene_.LoadAsyncXML(cache.GetFile(scene));

	SubscribeToEvent("AsyncLoadFinished", "HandleAsyncLoadFinished");
}

void HandleAsyncLoadFinished(StringHash type, VariantMap& data)
{
	UnsubscribeFromEvent("AsyncLoadFinished");

	newScene_ = data["Scene"].GetPtr();

	SubscribeToEvent("Update", "HandleDelayedStart");
}

void HandleDelayedStart(StringHash type, VariantMap& data)
{
	UnsubscribeFromEvent("Update");

	Node@ cameraNode = newScene_.GetChild("Camera", true);
	Camera@ newCamera = cameraNode.CreateComponent("Camera");

	Viewport@ viewport = Viewport(newScene_, cameraNode.GetComponent("Camera"));
	renderer.viewports[0] = viewport;

	scene_ = newScene_;
	camera_ = newCamera;
	newScene_ = null;
}
