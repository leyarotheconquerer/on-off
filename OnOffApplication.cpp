#include "OnOffApplication.h"

#include <Urho3D/AngelScript/Script.h>
#include <Urho3D/AngelScript/ScriptFile.h>
#include <Urho3D/IO/Log.h>
#include <Urho3D/Resource/ResourceCache.h>
#include <Urho3D/Resource/ResourceEvents.h>

using namespace OnOff;
using namespace Urho3D;

URHO3D_DEFINE_APPLICATION_MAIN(OnOffApplication)

OnOffApplication::OnOffApplication(Urho3D::Context* context) :
	Application(context),
	context_(context)
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
	context_->RegisterSubsystem(new Script(context_));
	script_ = context_->GetSubsystem<ResourceCache>()->GetResource<ScriptFile>("Scripts/Main.as");
	if (script_ && script_->Execute("void Start()"))
	{
		SubscribeToEvent(script_, E_RELOADSTARTED, URHO3D_HANDLER(OnOffApplication, HandleScriptReloadStarted));
		SubscribeToEvent(script_, E_RELOADFAILED, URHO3D_HANDLER(OnOffApplication, HandleScriptReloadFailed));
		SubscribeToEvent(script_, E_RELOADFINISHED, URHO3D_HANDLER(OnOffApplication, HandleScriptReloadFinished));
		return;
	}
	ErrorExit();
}

void OnOffApplication::Stop()
{
}

void OnOffApplication::HandleScriptReloadStarted(Urho3D::StringHash type, Urho3D::VariantMap& data)
{
	if (script_->GetFunction("void Stop()"))
	{
		script_->Execute("void Stop()");
	}
}

void OnOffApplication::HandleScriptReloadFailed(Urho3D::StringHash type, Urho3D::VariantMap& data)
{
	script_.Reset();
	ErrorExit();
}

void OnOffApplication::HandleScriptReloadFinished(Urho3D::StringHash type, Urho3D::VariantMap& data)
{
	if (!script_->Execute("void Start()"))
	{
		script_.Reset();
		ErrorExit();
	}
}
