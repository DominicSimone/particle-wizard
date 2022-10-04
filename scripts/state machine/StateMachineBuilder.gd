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
	
	for state_name in state_refcount.keys():
		if state_refcount[state_name] == 0 and state_name != "start":
			printerr("'", state_name, "' has no inbound transitions")
	
	if state_map.has("start"):
		return state_map["start"]
	else:
		return state_map.values()[0]
