class_name HostileEnemyActorComponent
extends ActorComponent


func get_action() -> Action:
	print("The %s wonders when it will get to take a real turn." % _parent_entity.name)
	return WaitAction.new(_parent_entity)
