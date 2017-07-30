#ifndef OnOffApplication_H
#define OnOffApplication_H

#include <Urho3D/Engine/Application.h>

namespace Urho3D
{
	class Context;
	class ScriptFile;
}

namespace OnOff
{
	URHO3D_EVENT(E_LEVELCOMPLETE, LevelComplete)
	{
		URHO3D_PARAM(P_NEXTLEVEL, NextLevel);          // Urho3D::String
		URHO3D_PARAM(P_DISPLAYMESSAGE, DisplayMessage);// boolean
	}

	URHO3D_EVENT(E_LEVELRESTART, LevelRestart)
	{
		URHO3D_PARAM(P_MESSAGE, Message);              // Urho3D::String
		URHO3D_PARAM(P_TYPE, Type);                    // Urho3D::String
		URHO3D_PARAM(P_DISPLAYMESSAGE, DisplayMessage);// boolean
	}

	URHO3D_EVENT(E_PLAYERDEATH, PlayerDeath)
	{
		URHO3D_PARAM(P_MESSAGE, Message);              // Urho3D::String
		URHO3D_PARAM(P_TYPE, Type);                    // Urho3D::String
		URHO3D_PARAM(P_DISPLAYMESSAGE, DisplayMessage);// boolean
	}

	URHO3D_EVENT(E_POWERACTIVATED, PowerActivated)
	{
		URHO3D_PARAM(P_POWER, Power);                  // float
	}

	URHO3D_EVENT(E_POWERDEACTIVATED, PowerDeactivated)
	{
		URHO3D_PARAM(P_POWER, Power);                  // float
	}

	URHO3D_EVENT(E_PICKUP, Pickup)
	{
		URHO3D_PARAM(P_PICKUPNODE, PickupNode);        // Urho3D::Node
		URHO3D_PARAM(P_PICKUPERNODE, PickuperNode);    // Urho3D::Node
		URHO3D_PARAM(P_TYPE, Type);                    // Urho3D::String
		URHO3D_PARAM(P_POWER, Power);                  // float
	}

	class OnOffApplication : public Urho3D::Application
	{
		URHO3D_OBJECT(OnOffApplication, Urho3D::Application);

	public:
		OnOffApplication(Urho3D::Context* context);
		virtual ~OnOffApplication() {}

	protected:
		virtual void Setup();
		virtual void Start();
		virtual void Stop();

	private:
		void HandleScriptReloadStarted(Urho3D::StringHash type, Urho3D::VariantMap& data);
		void HandleScriptReloadFailed(Urho3D::StringHash type, Urho3D::VariantMap& data);
		void HandleScriptReloadFinished(Urho3D::StringHash type, Urho3D::VariantMap& data);

		Urho3D::Context* context_;
		Urho3D::SharedPtr<Urho3D::ScriptFile> script_;
	};
}

#endif //OnOffApplication_H
