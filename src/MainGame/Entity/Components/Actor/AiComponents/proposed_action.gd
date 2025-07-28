class_name ProposedAction
extends RefCounted

enum Priority {
	FALLBACK,
	LOW,
	MEDIUM,
	HIGH,
	FORCED,
}

var priority: Priority = Priority.LOW
var score: int = 0
var action: Action


func with_priority(priority: Priority) -> ProposedAction:
	self.priority = priority
	return self


func with_score(score: int) -> ProposedAction:
	self.score = score
	return self


func with_action(action: Action) -> ProposedAction:
	self.action = action
	return self
