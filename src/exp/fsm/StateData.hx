package exp.fsm;

import haxe.ds.ReadOnlyArray;

using tink.CoreApi;

abstract StateData<T, S:State<T>>(Pair<S, ReadOnlyArray<T>>) {
	public var state(get, never):S;
	public var next(get, never):ReadOnlyArray<T>;
	public inline function new(state, next) this = new Pair(state, next);
	inline function get_state() return this.a;
	inline function get_next() return this.b;
}