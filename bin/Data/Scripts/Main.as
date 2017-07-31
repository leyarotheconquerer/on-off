#include "Scripts/PlayerPower.as"

String currentLevel_;
String currentMessage_;
String currentTitle_;
Scene@ newScene_;
Scene@ scene_;
Camera@ camera_;
Timer timer_;

void Start()
{
	currentTitle_ = currentMessage_ = "";
	StartScene("Scenes/StartUp.xml");
	SubscribeToEvent("LevelComplete", "HandleLevelComplete");
	SubscribeToEvent("LevelRestart", "HandleLevelRestart");

	ui.root.defaultStyle = cache.GetResource("XMLFile", "UI/OnOffStyle.xml");
}

void Stop()
{
}

void HandleLevelComplete(StringHash type, VariantMap& data)
{
	currentTitle_ = "";
	currentMessage_ = "";
	if (data["DisplayMessage"].GetBool())
	{
		currentTitle_ = "Welcome to " + data["NextLevelTitle"].GetString();
		currentMessage_ = "Last Level Stats:\n";
		CollectLevelStats();
	}
	StartScene(data["NextLevel"].GetString());
}

void HandleLevelRestart(StringHash type, VariantMap& data)
{
	currentTitle_ = "";
	currentMessage_ = "";
	if (data["DisplayMessage"].GetBool())
	{
		if (data["Type"].GetString() == "Death")
		{
			currentTitle_ = "You Died";
		}
		else if (data["Type"].GetString() == "PlayerRestart")
		{
			currentTitle_ = "Restarting the Level";
		}
		currentMessage_ = data["Message"].GetString() + "\nLast Attempt Stats:\n";
		CollectLevelStats();
	}
	StartScene(currentLevel_);
}

void CollectLevelStats()
{
	float timeTaken = timer_.GetMSec(false);

	Node@[] playerNode = scene_.GetChildrenWithTag("player", true);
	PlayerPower@ playerPower = cast<PlayerPower>(playerNode[0].GetScriptObject("PlayerPower"));
	float power = playerPower.Power;
	float maxPower = playerPower.MaxPower;

	currentMessage_ = currentMessage_ +
		"Time Taken: " + timeTaken / 1000.f + " seconds\n" +
		"Power Remaining: " + power + "\n" +
		"Power Collected: " + maxPower;
}

void StartScene(String scene)
{
	currentLevel_ = scene;
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

	if (currentTitle_ != "")
	{
		log.Debug("Sending message: " + currentMessage_);
		VariantMap sendData;
		sendData["Dialog"] = "UI/Dialog.xml";
		sendData["Title"] = currentTitle_;
		sendData["Message"] = currentMessage_;
		sendData["Image"] = "";
		IntRect imageRect = IntRect(0, 0, 0, 0);
		sendData["ImageRect"] = imageRect;
		SendEvent("ShowDialog", sendData);
	}

	timer_.Reset();
}
