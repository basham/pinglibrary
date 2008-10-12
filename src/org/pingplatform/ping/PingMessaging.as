package org.pingplatform.ping {
	
	public class PingMessaging {
		
		[Bindable]
		public static var History:String = "";
		
		public function PingMessaging() {
		}

		public static function Message( message:String ):void {
			History += message;
			trace( message );
		}
		
	}
}