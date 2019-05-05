package exp.fsm;

import haxe.ds.ReadOnlyArray;

using tink.CoreApi;

class StateMachine<T, S:State<T>> {
	public var current(default, null):S;
	
	final states:Map<T, StateData<T, S>>;
	
	@:generic
	public static inline function create<T, S:State<T>>(init, rest) {
		return new StateMachine<T, S>([], init, rest);
	}
	
	function new(map, init:StateData<T, S>, rest:ReadOnlyArray<StateData<T, S>>) {
		states = map;
		
		add(init);
		for(data in rest) add(data);
		
		// init
		current = init.state;
		current.onActivate();
	}
	
	function add(data:StateData<T, S>) {
		var key = data.state.key;
		if(states.exists(key)) throw 'Duplicate state key: $key';
		states.set(key, data);
	}
	
	public function transit(to:T):Outcome<Noise, Error> {
		return
			if(current.key == to)
				Success(Noise);
			else if(canTransit(to)) {
				if(current != null) current.onDeactivate();
				current = states.get(to).state;
				current.onActivate();
				Success(Noise);
			} else {
				Failure(new Error('Unable to transit from "${current.key}" to "$to"'));
			}
	}
	
	public function canTransit(to:T) {
		return switch states.get(current.key) {
			case null: false;
			case v: v.next.indexOf(to) != -1;
		}
	}
}
