Scene@ scene_;
Camera@ camera_;

void Start()
{
	scene_ = Scene();
	scene_.LoadXML(cache.GetFile("Scenes/TestScene.xml"));

	Node@ cameraNode = scene_.GetChild("Camera");
	camera_ = cameraNode.CreateComponent("Camera");

	Viewport@ viewport = Viewport(scene_, cameraNode.GetComponent("Camera"));
	renderer.viewports[0] = viewport;
}

void Stop()
{
}
