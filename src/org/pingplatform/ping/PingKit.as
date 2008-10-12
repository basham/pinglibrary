package org.pingplatform.ping {
	
	import com.phidgets.PhidgetInterfaceKit;
	import com.phidgets.events.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class PingKit extends EventDispatcher {
		
		/*
		POLLY'S KIT 	76036
		TONY'S KIT		69610
		*/
		
		public static const KIT_CREATED:String = "kitCreatedEvent";
		public static const KIT_OPENED:String = "kitOpenedEvent";
		public static const KIT_ATTACHED:String = "kitAttachedEvent"; // Phidget Attached
		public static const KIT_DETACHED:String = "kitDetachedEvent"; // Phidget Detached
		
		public static const SENSOR_ATTACHED:String = "sensorAttachedEvent";
		
		private var kit:PhidgetInterfaceKit;
		private var _serialNumber:uint;
		private var _sensors:Array;
		//private var activeSensors:Array;
		
				
		public function PingKit( serialNumber:uint ) {
			_serialNumber = serialNumber;
			dispatchEvent( new Event( KIT_CREATED ) );
			connect();
		}
		 
		public function connect():void {
			kit = new PhidgetInterfaceKit();

			kit.addEventListener( PhidgetEvent.ATTACH, onAttach );
			kit.addEventListener( PhidgetEvent.DETACH, onDetach );
			kit.addEventListener( PhidgetErrorEvent.ERROR, onError );
			kit.addEventListener( PhidgetDataEvent.SENSOR_CHANGE, onSensorChange );

			kit.open( PingConfig.ADDRESS, PingConfig.PORT, PingConfig.PASSWORD, SerialNumber );
			
			dispatchEvent( new Event( KIT_OPENED ) );
		}
		
		public function get SerialNumber():uint {
			return _serialNumber;
		}
		
		public function get Sensors():Array {
			return _sensors;
		}
		
		public function Sensor( value:uint ):PingSensor {
			if (value >= kit.SensorCount)
				return null;
			return Sensors[ value ];
		}
		
		private function onAttach( event:PhidgetEvent ):void { 

			kit.Ratiometric = true;
			
			_sensors = new Array();
			
			//for( var i:uint = 0; i < kit.SensorCount; i++ )

				
			//sensorCorners = new Array( kit.SensorCount );
			//activeSensors = new Array( kit.SensorCount );
			
			for( var i:uint = 0; i < kit.SensorCount; i++ ) {
				_sensors.push( new PingSensor( this, i ) );
				kit.setSensorChangeTrigger( i, PingConfig.SENSOR_SENSITIVITY );
				// TODO: Phidget State not yet recieved from device (SensorCount)
				//if (AttachedSensorIndexes[i]) {
					//dispatchEvent( new Event( SENSOR_ATTACHED ) );
					//trace("+ SENSOR ATTACHED", i);
				//}
			}
			
			dispatchEvent( new Event( KIT_ATTACHED ) );
			dispatchEvent( event.clone() );
		}
		
		private function onDetach( event:PhidgetEvent ):void {
			dispatchEvent( new Event( KIT_DETACHED ) );
		}

		private function onError( event:PhidgetErrorEvent ):void {
			//Status = PING_ERROR;
		}
		
		private function onSensorChange( event:PhidgetDataEvent ):void {
			var index:uint = event.Index;
			Sensor(index).dispatch( event );
/*

			
			//checkSensorAttachment( index );
			
			//activeSensors[index] = true;
			
			//if ( sensorCorners[index] == undefined )
			//	return;
			
			//PingData.Corner( sensorCorners[index] ).dispatch( event );
			var pc:PingCorner = cornerBySensorIndex( index );
			
			if (pc == null)
				return;
				
			pc.dispatch( event );
			*/
		}
		
		override public function toString():String {
			var s:String = 'ACTIVE SENSORS: ';
			
			//s += (new Array()) + ' | ';
			
			//for( var i:int = 0; i < activeSensors.length; i++ )
				//if (activeSensors[i])
				//	s += i + ' ';

			for( var i:int = 0; i < 8; i++ )
				s += kit.getSensorValue(i) + ' ';
				
			return s;
		}
/*
		private function checkSensorAttachment( index:uint ):void {
			// Assumes the sensor associated with the index parameter is attached.
			// If the sensor is newly attached, clear ASI (building on next call)
			// and dispatch event, alterting a sensor has been attached.
			if (!AttachedSensorIndexes[ index ]) {
				clearAttachedSensorIndexes();
				dispatchEvent( new Event( SENSOR_ATTACHED ) );
				trace("+++ SENSOR ATTACHED", index);
			}
		}
		*/
		private var _attachedSensorIndexes:Array;
		
		public function get AttachedSensorIndexes():Array {
			// Return the cached Attached Sensor Indexes, if set
			if (_attachedSensorIndexes)
				return _attachedSensorIndexes;
			// Build and return all known attached sensors
			_attachedSensorIndexes = new Array(kit.SensorCount);
			for( var i:uint = 0; i < kit.SensorCount; i++ )
				_attachedSensorIndexes[i] = (kit.getSensorValue(i) > PingConfig.MIN_ATTACHED_SENSOR_VALUE);
			return _attachedSensorIndexes;
		}
		
		private function clearAttachedSensorIndexes():void {
			_attachedSensorIndexes = null;
		}
		
		private var cornerCache:Array = new Array(8);
		
		private function cornerBySensorIndex( sensorIndex:uint ):PingCorner {
			// If the PingCorner is in the cache, return it
			if (cornerCache[sensorIndex] != undefined)
				return cornerCache[sensorIndex] as PingCorner;
			// Not cached, so search for the PingCorner
			for each( var pc:PingCorner in PingData.Corners ) {
				var ps:PingSensor = pc.Sensor;
				if ( ps.Kit == this && ps.Index == sensorIndex ) {
					cornerCache[sensorIndex] = pc; // Caches PingCorner
					return pc;
				}
			}
			// No PingCorner assigned to this kit's sensor index
			return null;
		}
		
	}
}