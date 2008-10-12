package org.pingplatform.ping.events {
	
	import flash.events.Event;
	
	import org.pingplatform.ping.PingCornerData;
	import org.pingplatform.ping.PingSideData;
	
	public class PingSideDataEvent extends Event {
		
		public static const SENSOR_CHANGE:String = "onSideSensorChangeEvent";
		
		private var _index:int;
		private var _leftData:PingCornerData;
		private var _rightData:PingCornerData;
		private var _sideData:PingSideData;
			
		public function PingSideDataEvent( type:String, index:int, leftData:PingCornerData, rightData:PingCornerData, sideData:PingSideData,
			bubbles:Boolean = false, cancelable:Boolean = false ) {
			super(type, bubbles, cancelable);
			_index = index;
			_leftData = leftData;
			_rightData = rightData;
			_sideData = sideData;
		}
		
		override public function clone():Event {
			return new PingSideDataEvent(type, Index, LeftData, RightData, SideData, bubbles, cancelable);
		}
		
		public function get Index():int {
			return _index;
		}
		
		public function get LeftData():PingCornerData {
			return _leftData;
		}
		
		public function get RightData():PingCornerData {
			return _rightData;
		}
		
		public function get SideData():PingSideData {
			return _sideData;
		}
		
	}
}