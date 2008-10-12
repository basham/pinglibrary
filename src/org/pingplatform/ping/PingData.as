package org.pingplatform.ping {
	
	import com.phidgets.PhidgetManager;
	import com.phidgets.events.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
		
	public class PingData {
		
		public static const PING_CALIBRATED:String = "pingCalibratedEvent";
		
		public static const SIDE_A:uint = 0;
		public static const SIDE_B:uint = 1;
		public static const SIDE_C:uint = 2;
		public static const SIDE_D:uint = 3;
		
		public static const CORNER_AL:uint = 0;
		public static const CORNER_AR:uint = 1;
		public static const CORNER_BL:uint = 2;
		public static const CORNER_BR:uint = 3;
		public static const CORNER_CL:uint = 4;
		public static const CORNER_CR:uint = 5;
		public static const CORNER_DL:uint = 6;
		public static const CORNER_DR:uint = 7;
			
		public static const SERVER_CONNECTED:String = "serverConnectedEvent"; // Server Connected
		public static const SERVER_DISCONNECTED:String = "serverDisconnectedEvent"; // Server Disconnected
		
		public static var enableSmoothing:Boolean = true;
		public static var smoothing:uint = PingConfig.SENSOR_SMOOTHING;
		public static var AverageType:String = PingConfig.SENSOR_NORMALIZATION_ALGORITHM;
		public static var truncateExtremes:Boolean = true;
		public static var truncatePercentage:Number = PingConfig.SENSOR_TRUNCATE_PERCENTAGE;
		
		private static var _status:int;
		
		private static var _corners:Array = new Array( 8 );
		private static var _sides:Array = new Array( 4 );
		private static var _kits:ArrayCollection;
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		private static var manager:PhidgetManager;
		
		
		public function PingData() {
		}
			
		public static function Connect():void { 
			manager = new PhidgetManager();
			_kits = new ArrayCollection();

			manager.addEventListener( PhidgetManagerEvent.CONNECT, onConnect );
			manager.addEventListener( PhidgetManagerEvent.DISCONNECT, onDisconnect );
			manager.addEventListener( PhidgetManagerEvent.ATTACH, onAttach );
			manager.addEventListener( PhidgetManagerEvent.DETACH, onDetach );
			manager.addEventListener( PhidgetErrorEvent.ERROR, onError );
			
			manager.open( PingConfig.ADDRESS, PingConfig.PORT, PingConfig.PASSWORD );
		}
		
		private static function onConnect( event:PhidgetManagerEvent ):void {
			dispatchEvent( new Event( SERVER_CONNECTED ) );
		}
		
		private static function onDisconnect( event:PhidgetManagerEvent ):void {
			dispatchEvent( new Event( SERVER_DISCONNECTED ) );
		}
		
		private static function onAttach( event:PhidgetManagerEvent ):void {
			var kit:PingKit = new PingKit( event.Device.serialNumber );
			kit.addEventListener( PhidgetEvent.ATTACH, onKitAttach );
			_kits.addItem( kit );
		}
		
		private static function onDetach( event:PhidgetManagerEvent ):void {
		}
		
		private static function onError( event:PhidgetErrorEvent ):void {
			trace( event.Error.message );
		}
		
		private static function onKitAttach( event:Event ):void {
			_Calibrate();
		}
		
		private static function _Calibrate():void {
			
			//var k:PingKit = Kit(0);
			//k.sensorCorners[0] = PingData.CORNER_AL;
			//k.sensorCorners[1] = PingData.CORNER_AR;
			//k.sensorCorners[2] = PingData.CORNER_CL;
			//k.sensorCorners[3] = PingData.CORNER_CR;
			
			var sensorCorners:Array = new Array(8);
			sensorCorners[ CORNER_AL ] = Kit(0).Sensor( 0 );
			sensorCorners[ CORNER_AR ] = Kit(0).Sensor( 1 );
			sensorCorners[ CORNER_BL ] = Kit(0).Sensor( 2 );
			sensorCorners[ CORNER_BR ] = Kit(0).Sensor( 3 );
			sensorCorners[ CORNER_CL ] = Kit(0).Sensor( 4 );
			sensorCorners[ CORNER_CR ] = Kit(0).Sensor( 5 );
			sensorCorners[ CORNER_DL ] = Kit(0).Sensor( 6 );
			sensorCorners[ CORNER_DR ] = Kit(0).Sensor( 7 );
			
			for ( var i:uint = 0; i < 8; i++ )
				Corners[ i ] = new PingCorner( i, sensorCorners[ i ] );
			
			for ( i = 0; i < 4; i++ ) {
				var ps:PingSide = new PingSide( Corner( i * 2 ), Corner( (i * 2) + 1 ), i );
				Sides[ i ] = ps;
				if (i == 0)
					ps.addEventListener( PingSide.SIDE_CALIBRATED, onSideCalibrated );
			}
			
			Calibrate();
		}
		
		private static function onSideCalibrated( event:Event ):void {
			PingData.dispatchEvent( new Event( PING_CALIBRATED ) );
			PingMessaging.Message( "Ping SIDE Calibrated" );
		}
		
		public static function Calibrate():void {
			PingMessaging.Message( "Calibrating ..." );
			for each ( var pc:PingCorner in Corners )
				pc.calibrate();
		}
		
		

		public static function Kit( value:uint ):PingKit {
			if ( value > Kits.length )
				return null;
			return Kits.getItemAt( value ) as PingKit;
		}

		public static function get Kits():ArrayCollection {
			return _kits;
		}
		
		public static function Side( value:uint ):PingSide {
			if ( value > 3 )
				return null;
			return Sides[ value ];
		}

		public static function get Sides():Array {
			return _sides;
		}
		
		public static function Corner( value:uint ):PingCorner {
			if ( value > 7 )
				return null;
			return Corners[ value ];
		}
		
		public static function get Corners():Array {
			return _corners;
		}




		/*
		A static class cannot dispatch events, only instantiated
		objects. Thus, we create an object to handle all events for
		the static PingData class.
		*/
		
		public static function addEventListener( type:String, listener:Function,
			useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
           
		public static function dispatchEvent( event:Event ):Boolean {
			return dispatcher.dispatchEvent(event);
		}
    
		public static function hasEventListener( type:String ):Boolean {
			return dispatcher.hasEventListener(type);
		}
    
		public static function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
                   
		public static function willTrigger( type:String ):Boolean {
			return dispatcher.willTrigger(type);
		}

		
		/*
		
		TODO:
		-----
		
		The Connect call creates a new PingKit object
		for every Serial Number provided.
		
		A configuration script determines which sensors
		belong to which corners and sides.
				
		------------------------------------------------
		
		Array[ 0 - 7 ] of Corners
		Corners reference Kit, Sensor Index
		
		OnConnect, all Kits broadcast the available
		sensor indexes. Sensors assigned to Corners
		on configuration.
		
		
		================================================
		
		
		CONFIGURATION:
		--------------
		
		*/

	}
}