package org.pingplatform.ping {

	public class PingConstants {
		
		public static const KIT_CREATED:int = 0;
		public static const KIT_OPENED:int = 1;
		
		public static const SERVER_CONNECTED:int = 2; // Server Connected
		public static const SERVER_DISCONNECTED:int = 3; // Server Disconnected
		
		public static const KIT_ATTACHED:int = 4; // Phidget Attached
		public static const KIT_DETACHED:int = 5; // Phidget Detached
		
		public function PingConstants() {
		}

		//public function toString():String {
		//	return( 'VALUE: ' + value + ', METRIC: ' + metric + ', PERCENTAGE: ' + perc + ', BOOL: ' + bool );
		//}
		
	}
}