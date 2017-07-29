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
