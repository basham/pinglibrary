package org.pingplatform.ping {
	
	import com.phidgets.events.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.pingplatform.ping.events.PingCornerDataEvent;
	import org.pingplatform.ping.events.PingSideDataEvent;
	
	public class PingSide extends EventDispatcher {

		public static const SIDE_CALIBRATING:String = "sideCalibratingEvent";
		public static const SIDE_CALIBRATED:String = "sideCalibratedEvent";
		
		private var _leftCorner:PingCorner;
		private var _rightCorner:PingCorner;
		private var _sideIndex:uint;
		private var _data:PingSideData;
		private var _calibrationStatus:uint = 0;
		
		public function PingSide( leftCorner:PingCorner, rightCorner:PingCorner, sideIndex:uint ) {
			_leftCorner = leftCorner;
			_rightCorner = rightCorner;
			_sideIndex = sideIndex;
			
			Left.addEventListener( PingCorner.CORNER_CALIBRATING, onCalibrating );
			Right.addEventListener( PingCorner.CORNER_CALIBRATING, onCalibrating );

			Left.addEventListener( PingCorner.CORNER_CALIBRATED, onCalibrated );
			Right.addEventListener( PingCorner.CORNER_CALIBRATED, onCalibrated );
			
			Left.addEventListener( PingCornerDataEvent.SENSOR_CHANGE, onCornerChange );
			Right.addEventListener( PingCornerDataEvent.SENSOR_CHANGE, onCornerChange );
		}
		
		public function get Left():PingCorner {
			return _leftCorner;
		}
			
		public function get Right():PingCorner {
			return _rightCorner;
		}
		
		public function get Index():uint {
			return _sideIndex;
		}
		
		public function get Data():PingSideData {
			return _data;
		}
		
		public function set Data( value:PingSideData ):void {
			_data = value;
		}
		
		private function onCalibrating( event:Event ):void {
			_calibrationStatus = 0;
			dispatchEvent( new Event( SIDE_CALIBRATING ) );
		}

		private function onCalibrated( event:Event ):void {
			_calibrationStatus++;
			if (_calibrationStatus == 2)
				dispatchEvent( new Event( SIDE_CALIBRATED ) );
		}
		
		private function onCornerChange( event:PingCornerDataEvent ):void {
			Data = derive();
			dispatchEvent( new PingSideDataEvent( PingSideDataEvent.SENSOR_CHANGE, Index, Left.Data, Right.Data, Data ) );
		}

		private function derive():PingSideData {
			var data:PingSideData = new PingSideData();
			var left:PingCornerData = Left.Data;
			var right:PingCornerData = Right.Data;
			var bool:Boolean, percStart:Number, percEnd:Number, percCenter:Number, percSize:Number;
			
			bool = left.bool && right.bool;
			percStart = left.perc;
			percEnd = 1 - right.perc;
			percSize = percEnd - percStart;
			percCenter = percStart + ( percSize / 2 );
			
			data.bool = bool;
			data.percStart = percStart;
			data.percEnd = percEnd;
			data.percCenter = percCenter;
			data.percSize = percSize;
			
			return data;
		}
		
	}
}