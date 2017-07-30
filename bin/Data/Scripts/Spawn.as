class Spawn: ScriptObject
{
	String SpawnItem;
	String SpawnName;

	Spawn()
	{
		SpawnItem = "";
		SpawnName = "";
	}

	void DelayedStart()
	{
		Node@ parent = node.parent;

		if (SpawnItem != "")
		{
			Node@ newNode = parent.CreateChild(SpawnName);
			XMLFile@ xmlFile = cache.GetResource("XMLFile", SpawnItem);
			newNode.LoadXML(xmlFile.root);

			newNode.position = node.position;
			newNode.scale = node.scale;
			newNode.rotation = node.rotation;
			for(int i = 0; i < node.tags.length; i++)
			{
				newNode.AddTag(node.tags[i]);
			}

			node.Remove();
		}
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(SpawnItem);
		serializer.WriteString(SpawnName);
	}

	void Load(Deserializer& deserializer)
	{
		SpawnItem = deserializer.ReadString();
		SpawnName = deserializer.ReadString();
	}

	void Stop()
	{
	}
}
