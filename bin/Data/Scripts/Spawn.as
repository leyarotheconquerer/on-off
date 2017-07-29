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
		log.Debug(node.name + " spawning...");
		Node@ parent = node.parent;

		if (SpawnItem != "")
		{
			Node@ newNode = parent.CreateChild(SpawnName);
			log.Debug("Create new node");
			newNode.position = node.position;
			newNode.scale = node.scale;
			newNode.rotation = node.rotation;
			log.Debug("loc=" + newNode.position.ToString() + ", rot=" + newNode.rotation.ToString() + ", scale=" + newNode.scale.ToString());
			log.Debug("loc=" + node.position.ToString() + ", rot=" + node.rotation.ToString() + ", scale=" + node.scale.ToString());
			XMLFile@ xmlFile = cache.GetResource("XMLFile", SpawnItem);
			newNode.LoadXML(xmlFile.root);

			node.Remove();
			log.Debug("Remove self");
		}
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(SpawnItem);
		serializer.WriteString(SpawnName);
	}

	void Load(Deserializer& deserializer)
	{
		log.Debug("Deserializing");
		SpawnItem = deserializer.ReadString();
		log.Debug("SpawnItem: " + SpawnItem);
		SpawnName = deserializer.ReadString();
		log.Debug("SpawnName: " + SpawnName);
	}

	void Stop()
	{
	}
}
