package exp.fsm;

using tink.CoreApi;

class StateMachine<T, S:State<T>> {
	public var current(default, null):T;
	
	var states:Map<T, S>;
	var nexts:Map<T, Array<T>>;
	
	@:generic
	public static inline function create<T, S:State<T>>() {
		return new StateMachine<T, S>([], []);
	}
	
	function new(states, nexts) {
		this.states = states;
		this.nexts = nexts;
	}
	
	public function add(state:S, next:Array<T>) {
		states.set(state.type, state);
		nexts.set(state.type, next.copy());
	}
	
	public function transit(to:T):Outcome<Noise, Error> {
		return
			if(current == to)
				Success(Noise);
			else switch states.get(to) {
				case null:
					Failure(new Error('State "$to" doesn\'t exist'));
					
				case nextState:
					if(current == null || canTransit(current, to)) {
						if(current != null)
							switch states.get(current) {
								case null:
								case currentState: currentState.onDeactivate();
							}
						nextState.onActivate();
						current = to;
						Success(Noise);
					} else {
						Failure(new Error('Unable to transit from "$current" to "$to"'));
					}
			}
	}
	
	function canTransit(from:T, to:T) {
		return switch nexts.get(from) {
			case null: false;
			case v: v.indexOf(to) != -1;
		}
	}
}
