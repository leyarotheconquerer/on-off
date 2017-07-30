#include "Scripts/PlayerPower.as"

Scene@ newScene_;
Scene@ scene_;
Camera@ camera_;
Timer timer_;

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
	float timeTaken = timer_.GetMSec(false);
	log.Debug("You took " + timeTaken / 1000.f + " seconds to solve the level");

	Node@[] playerNode = scene_.GetChildrenWithTag("player", true);
	PlayerPower@ playerPower = cast<PlayerPower>(playerNode[0].GetScriptObject("PlayerPower"));
	float power = playerPower.Power;
	log.Debug("You had " + power + " power remaining");

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

	timer_.Reset();
}
