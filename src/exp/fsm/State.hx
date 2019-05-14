package exp.fsm;

import haxe.ds.ReadOnlyArray;
interface State<T> {
	final key:T;
	function canTransitTo(key:T):Bool;
	function onActivate():Void;
	function onDeactivate():Void;
}

class BasicState<T> implements State<T> {
	public final key:T;
	final next:ReadOnlyArray<T>;
	public function new(key, next) {
		this.key = key;
		this.next = next;
	}
	public function canTransitTo(key:T) return next.indexOf(key) != -1;
	public function onActivate() {}
	public function onDeactivate() {}
}