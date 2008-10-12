package org.pingplatform.ping {

	public class PingCornerData	{
		
		public var raw:uint;
		public var value:int;
		public var mm:uint;
		public var perc:Number;
		public var bool:Boolean;
		
		public function PingCornerData() {
		}

		public function toString():String {
			return( 'RAW: ' + raw + ', VALUE: ' + value + ', MM: ' + mm + ', PERCENTAGE: ' + perc + ', BOOL: ' + bool );
		}
		
	}
}