#include "OnOffApplication.h"

#include <Urho3D/IO/Log.h>

using namespace OnOff;
using namespace Urho3D;

URHO3D_DEFINE_APPLICATION_MAIN(OnOffApplication)

OnOffApplication::OnOffApplication(Urho3D::Context* context) :
	Application(context)
{
}

void OnOffApplication::Setup()
{
	engineParameters_["FullScreen"] = false;
	engineParameters_["WindowTitle"] = "On/Off";
}

void OnOffApplication::Start()
{
	URHO3D_LOGDEBUG("I am running");
}

void OnOffApplication::Stop()
{
}
