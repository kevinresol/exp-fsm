package exp.fsm;

import haxe.ds.ReadOnlyArray;

class State<T> {
	public final key:T;
	public final next:ReadOnlyArray<T>;
	public function new(key, next) {
		this.key = key;
		this.next = next;
	}
	public function onActivate():Void {}
	public function onDeactivate():Void {}
}