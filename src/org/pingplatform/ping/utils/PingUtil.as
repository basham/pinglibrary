package org.pingplatform.ping.utils {
	
	public class PingUtil {

		public static function getSideByCorner( corner:uint ):uint {
			if (corner % 2 == 1) // Corner Id is Odd, e.g. CORNER_BR = 3
				corner--;
			return corner / 2;
		}
		
		public static function getAdjacentCorner( corner:uint ):uint {
			return (corner % 2 == 1) ? corner-- : corner++;
		}
		
	}
}