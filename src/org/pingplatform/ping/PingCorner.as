package org.pingplatform.ping {
	
	import com.phidgets.events.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.pingplatform.ping.events.PingCornerDataEvent;
	import org.pingplatform.ping.events.PingSensorDataEvent;
	
	public class PingCorner extends EventDispatcher {
		
		public static const CORNER_CALIBRATING:String = "cornerCalibratingEvent";
		public static const CORNER_CALIBRATED:String = "cornerCalibratedEvent";
		
		private var _index:uint;
		private var _sensor:PingSensor;
		private var _data:PingCornerData;
		
				
		public function PingCorner( index:uint, longSensor:PingSensor, shortSensor:PingSensor = null ) {
			_sensor = longSensor;
			_data = new PingCornerData();

			Sensor.addEventListener( PingSensor.SENSOR_CALIBRATED, onCalibrated );
			Sensor.addEventListener( PingSensorDataEvent.SENSOR_CHANGE, onSensorChange );
		}

		public function get Index():int {
			return _index;
		}
		
		public function get Sensor():PingSensor {
			return _sensor;
		}
		
		public function get Data():PingCornerData {
			return _data;
		}
		
		public function set Data( value:PingCornerData ):void {
			_data = value;
		}

		public function calibrate():void {
			dispatchEvent( new Event( CORNER_CALIBRATING ) );
			Sensor.calibrate();
		}
		
		private function onCalibrated( event:Event ):void {
			dispatchEvent( new Event( CORNER_CALIBRATED ) );
		}
		
		private function onSensorChange( event:PingSensorDataEvent ):void {
			Data = event.Data;
			dispatchEvent( new PingCornerDataEvent( PingCornerDataEvent.SENSOR_CHANGE, Index, Data ) );
		}

	}
}