package exp.fsm;

class State<T> {
	public final key:T;
	public function new(key) this.key = key;
	public function onActivate():Void {}
	public function onDeactivate():Void {}
}