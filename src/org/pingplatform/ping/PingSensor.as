package org.pingplatform.ping {
	
	import com.phidgets.events.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.pingplatform.ping.events.PingSensorDataEvent;
	import org.pingplatform.ping.utils.Normalize;
	
	public class PingSensor extends EventDispatcher {
		
		public static const SENSOR_ATTACHED:String = "sensorAttachedEvent";
		public static const SENSOR_DETACHED:String = "sensorDetachedEvent";
		
		public static const SENSOR_UNCALIBRATED:String = "sensorUncalibratedEvent"; // Not used, remove?
		public static const SENSOR_CALIBRATING:String = "sensorCalibratingEvent";
		public static const SENSOR_CALIBRATED:String = "sensorCalibratedEvent";
		
		private var _index:uint;
		private var _kit:PingKit;
		private var _data:PingCornerData;

		private var _min:uint = 0;
		private var _attempts:uint = 0;
		private var _calibrations:uint = 0;
		private var _calibrating:Boolean = false;
		
		private var _dataLog:Array;
		
		
		public function PingSensor( kit:PingKit, index:uint ) {
			_kit = kit;
			_index = index;
			_data = new PingCornerData();
			_dataLog = new Array();
		}

		public function get Index():int {
			return _index;
		}
		
		public function get Kit():PingKit {
			return _kit;
		}
		
		public function get Data():PingCornerData {
			return _data;
		}
		
		public function set Data( value:PingCornerData ):void {
			_data = value;
			_calibrate();
		}

		public function get Min():uint {
			return _min;
		}
		
		public function set Min( value:uint ):void {
			_min = value;
		}
		
		public function get Max():uint {
			return PingConfig.CALIBRATION_MAX_RAW_VALUE;
		}
		
		public function get Res():uint {
			return Max - Min;
		}

		public function calibrate():void {
			_calibrate(true);
		}
		
		public function dispatch( event:PhidgetDataEvent ):void {
			Data = derive( uint(event.Data) );
			dispatchEvent( new PingSensorDataEvent( PingSensorDataEvent.SENSOR_CHANGE, event.Index, Data ) );
		}

		private function derive( raw:uint ):PingCornerData {
			var data:PingCornerData = new PingCornerData();
			var value:int, mm:uint, perc:Number, bool:Boolean;
			
			// Smoothing needs at least 2 samples of data to work
			if ( PingData.enableSmoothing && PingData.smoothing > 1 ) {
				// Place the Raw value at the beginning index of the data log history
				_dataLog.unshift( raw );
				
				// Remove any excess data history
				// TODO: Add a timestamp to the data, so old data (eg 5 seconds)
				// is automatically expunged.
				while( _dataLog.length > PingData.smoothing )
					_dataLog.pop();
				
				//raw = Normalize.Linear( _dataLog );
				raw = Normalize.Average( _dataLog, PingData.AverageType );
			}
			
			value = Max - raw;
			mm = ( 9600 / (raw - 20) ) * 10;
			perc = ( mm - 200 ) / ( PingConfig.MIN_PERCENTAGE_VALUE ); // 711 says: calculate me!
			perc = perc > 1 ? 1 : ( perc < 0 ? 0 : perc );
			bool = raw > Min; // OR: perc < 1
			
			data.raw = raw;
			data.value = value;
			data.mm = mm;
			data.perc = perc;
			data.bool = bool;
			
			return data;
		}
		
		private function _calibrate( startCalibrating:Boolean = false ):void {
			
			if (startCalibrating) {
				_calibrating = true;
				dispatchEvent( new Event( SENSOR_CALIBRATING ) );
			}
				
			if (!_calibrating)
				return;
			
			//trace('SENSOR Calibration', Index, Min);
			
			// The sensor is calibrated, since it accurately sees nothing in the way
			// for the given Min value. Tack on a buffer to Min, since you can't gurantee
			// the particular calibration will prove accurate the entire run.
			if (_attempts == PingConfig.CALIBRATION_MIN_SUCCESSFUL_ATTEMPTS) {
				_calibrating = false;
				_calibrations = 0;
				_attempts = 0;
				Min += PingConfig.CALIBRATION_BUFFER;
				dispatchEvent( new Event( SENSOR_CALIBRATED ) );
				return;
			}

			if (_calibrations == 0)	// Reset Min if this is the first calibration set
				Min = 0;
			
			if (Data.bool) { // Adjust Min if the sensor detects anything
				Min += PingConfig.CALIBRATION_SKIP_INTERVAL;
				_calibrations++;
				_attempts = 0;
			}
			else // Successful attempt; nothing is blocking the sensor
				_attempts++;
		}
		
	}
}