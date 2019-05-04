package ;

import tink.unit.*;
import tink.testrunner.*;
import exp.fsm.*;

using tink.CoreApi;

@:asserts
class RunTests {

	static function main() {
		Runner.run(TestBatch.make([
			new RunTests(),
		])).handle(Runner.exit);
	}
	
	function new() {}
	
	public function test() {
		
		var fsm:StateMachine<String, TestState> = StateMachine.create();
		var logs = [];
		function log(name:String, event:String) logs.push('$name:$event');
		fsm.add(new TestState('foo', log), ['bar']);
		fsm.add(new TestState('bar', log), ['baz']);
		fsm.add(new TestState('baz', log), ['foo']);
		
		asserts.assert(fsm.transit('foo').isSuccess());
		asserts.assert(!fsm.transit('baz').isSuccess());
		asserts.assert(fsm.transit('bar').isSuccess());
		asserts.assert(fsm.transit('baz').isSuccess());
		asserts.assert(logs.join(',') == 'foo:enter,foo:exit,bar:enter,bar:exit,baz:enter');
		return asserts.done();
	}
	
}

class TestState extends State<String> {
	var log:String->String->Void;
	public function new(type, log) {
		super(type);
		this.log = log;
	}
	override function onActivate():Void log(type, 'enter');
	override function onDeactivate():Void log(type, 'exit');
}