class_name SMBuilder

# Takes in a Dictionary of 'states' (transitions and behaviors) that use names instead of
# referring directly to other states. Builds the state objects and correctly links
# references to each other.
"""
{
	"state_name": [
		[Behavior.new(), AnotherBehavior.new()],
		{
			"other state": [RandomChance.new(0.5)],
		}
	],
	"other_state": [
		[Behavior.new(), AnotherBehavior.new()],
		{
			"state_name": [RandomChance.new(0.5)],
		}
	]
}
"""
static func build(def: Dictionary) -> State:
	var state_map: Dictionary = {}
	var state_refcount: Dictionary = {}
	
	# First pass to collect all the state names and create 'empty' state objects
	for state_name in def.keys():
		# Behaviors don't relate to state graph, and can be set on init with no issue
		state_map[state_name] = State.new(def[state_name][0], [])
		state_map[state_name].name = state_name
		state_refcount[state_name] = 0
	
	# Link states' transitions to the existing state objects
	for state_name in def.keys():
		# [0] is behaviors array, [1] is transitions dictionary. Refer to top comment
		var transitions_dict = def[state_name][1]
		var transitions = []
		for dest_state_name in transitions_dict.keys():
			if not state_map.has(dest_state_name):
				printerr("Missing state '", dest_state_name, "' in state machine.")
				return null
			state_refcount[dest_state_name] += 1
			transitions.append(Transition.new(state_map[dest_state_name], transitions_dict[dest_state_name]))
		state_map[state_name].transitions = transitions
	
	var initial_state = "start" if state_map.has("start") else state_map.keys()[0]
	
	for state_name in state_refcount.keys():
		if state_refcount[state_name] == 0 and state_name != initial_state:
			printerr("'", state_name, "' has no inbound transitions")
	
	return state_map[initial_state]


static func get_state_machine(identifier: String):
	match identifier:
		"debug_machine": return debug_machine()
		"green_gem": return green_gem()
	printerr("'", identifier, "' state machine not found.")

# TODO
static func green_gem():
	return build({
		"inactive": [
			[],
			{
				"activation": [MatchEvent.new(EEvent.Types.PLAYER_DETECTION)]
			}
		],
		"activation": [
			[CallFunc.new("add_shield"), CallFunc.new("set_active")],
			{
				"activated": [Timed.new(0)]
			}
		],
		"activated": [
			[Shimmy.new(3, 0.5)],
			{
				"stop_and_shoot": [Timed.new(10), RandomChance.new(0.1)]
			}
		],
		"stop_and_shoot": [
			[Cast.new(preload("res://PlayerShot.tscn"), 0, 1)],
			{
				"activated": [Timed.new(1.5)]
			}
		]
	})

static func debug_machine():
	return build({
		"start": [
			[Talk.new(["Greetings, cowards."])],
			{
				"shimmy": [Timed.new(1)]
			}
		],
		"shimmy": [
			[Shimmy.new(3, 0.5)],
			{
				"stop_and_shoot": [Timed.new(10), RandomChance.new(0.1)]
			}
		],
		"stop_and_shoot": [
			[Cast.new(preload("res://PlayerShot.tscn"), 0, 1)],
			{
				"shimmy": [Timed.new(1.5)]
			}
		]
	})
