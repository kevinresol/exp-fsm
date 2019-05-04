package exp.fsm;

class State<T> {
	public final type:T;
	public function new(type) this.type = type;
	public function onActivate():Void {}
	public function onDeactivate():Void {}
}