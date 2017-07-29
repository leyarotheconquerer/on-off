#ifndef OnOffApplication_H
#define OnOffApplication_H

#include <Urho3D/Engine/Application.h>

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
	};
}

#endif //OnOffApplication_H
