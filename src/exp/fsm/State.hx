package exp.fsm;

interface State<T> {
	final key:T;
	function canTransitTo(key:T):Bool;
	function onActivate():Void;
	function onDeactivate():Void;
}