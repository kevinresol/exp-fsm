package exp.fsm;

import haxe.ds.ReadOnlyArray;
import tink.state.State as Value;
import tink.state.Observable;

using tink.CoreApi;

class StateMachine<T, S:State<T>> {
	public var current(get, never):S;
	
	final value:Value<S>;
	final states:Map<T, S>;
	
	@:generic
	public static inline function create<T, S:State<T>>(states) {
		return new StateMachine<T, S>([], states);
	}
	
	function new(map, list:ReadOnlyArray<S>) {
		states = map;
		for(state in list) add(state);
		
		// init
		var init = list[0];
		value = new Value(init);
		init.onActivate();
	}
	
	inline function add(state:S) {
		var key = state.key;
		if(states.exists(key)) throw 'Duplicate state key: $key';
		states.set(key, state);
	}
	
	public function transit(to:T):Outcome<Noise, Error> {
		return
			if(current.key == to)
				Success(Noise);
			else if(!states.exists(to)) 
				Failure(new Error('State key "$to" does not exist'));
			else if(canTransit(to)) {
				if(current != null) current.onDeactivate();
				var next = states.get(to);
				value.set(next);
				next.onActivate();
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
	
	public inline function observe():Observable<S> return value;
	inline function get_current() return value.value;
}
