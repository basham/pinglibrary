package org.pingplatform.ping.events {
	
	import flash.events.Event;
	
	import org.pingplatform.ping.PingCornerData;
	
	public class PingSensorDataEvent extends Event {
		
		public static const SENSOR_CHANGE:String = "onSensorChangeEvent";
		
		private var _index:uint;
		private var _data:PingCornerData;
		
		public function PingSensorDataEvent( type:String, index:uint, data:PingCornerData,
			bubbles:Boolean = false, cancelable:Boolean = false ) {
			super(type, bubbles, cancelable);
			_index = index;
			_data = data;
		}
		
		override public function clone():Event {
			return new PingCornerDataEvent(type, Index, Data, bubbles, cancelable);
		}
		
		public function get Index():int {
			return _index;
		}
		
		public function get Data():PingCornerData {
			return _data;
		}
		
	}
}