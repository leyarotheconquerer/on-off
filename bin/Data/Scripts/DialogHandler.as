class DialogHandler: ScriptObject
{
	private Array<UIElement@> dialogs_;

	void Start()
	{
		SubscribeToEvent("MouseButtonDown", "HandleMouseButtonDown");
		SubscribeToEvent("ShowDialog", "HandleShowDialog");
	}

	void Stop()
	{
		ClearDialogs();
	}

	void HandleShowDialog(StringHash type, VariantMap& data)
	{
		String dialog = data["Dialog"].GetString();
		String title = data["Title"].GetString();
		String message = data["Message"].GetString();
		String image = data["Image"].GetString();
		IntRect rect = data["ImageRect"].GetIntRect();

		UIElement@ dialogElement = ui.root.LoadChildXML(cache.GetResource("XMLFile", dialog));

		if (title != "")
		{
			Text@ titleElement = dialogElement.GetChild("Title", true);
			if (titleElement !is null)
			{
				titleElement.text = title;
			}
		}

		if (message != "")
		{
			Text@ messageElement = dialogElement.GetChild("Message", true);
			if (messageElement !is null)
			{
				messageElement.text = message;
			}
		}

		if (image != "")
		{
			UIElement@ imageElement = dialogElement.GetChild("Image", true);
			if (imageElement !is null)
			{
				imageElement.SetAttribute("Image Rect", Variant(rect));
				// TODO: Figure out how to get the types correct in this context
				/*Texture2D@ imageTexture = cache.GetResource("Texture2D", image);
				imageElement.SetAttribute("Texture", imageTexture);*/
			}
		}

		dialogs_.Push(dialogElement);
	}

	void HandleMouseButtonDown(StringHash type, VariantMap& data)
	{
		if (data["Button"] == MOUSEB_RIGHT)
		{
			ClearDialogs();
		}
	}

	private void ClearDialogs()
	{
		for(int i = dialogs_.length - 1; i >= 0; i--)
		{
			ui.root.RemoveChild(dialogs_[i]);
		}
		dialogs_.Clear();
	}
}
