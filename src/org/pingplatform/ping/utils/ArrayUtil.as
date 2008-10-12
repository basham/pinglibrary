package org.pingplatform.ping.utils {
	
	public class ArrayUtil {
		
		// Finds the Index of the smallest value in an array
		public static function MinIndex( values:Array ):uint {
			var minIndex:uint = 0;
			for( var i:uint = 0; i < values.length; i++ )
				if ( values[ i ] < values[ minIndex ] )
					minIndex = i;
			return minIndex;
		}
		
		// Finds the Index of the largest value in an array
		public static function MaxIndex( values:Array ):uint {
			var maxIndex:uint = 0;
			for( var i:uint = 0; i < values.length; i++ )
				if ( values[ i ] > values[ maxIndex ] )
					maxIndex = i;
			return maxIndex;
		}

		// Removes High and Lows from an array without modifying the order of the array
		public static function TruncateExtremes( values:Array, percentage:Number = .25 ):Array {
			// Only Truncate larger arrays
			if ( values.length < 3 )
				return values;
			
			percentage = ( percentage < 0 ) ? 0 : ( ( percentage > 1 ) ? 1 : percentage );
			
			// Number of Highs and Lows to remove
			// E.g. 2 means remove 2 Maxs, 2 Mins
			var extremes:uint = Math.floor( values.length * percentage / 2 );
			
			while( extremes > 0 ) {
				values.splice( MinIndex( values ), 1 );
				values.splice( MaxIndex( values ), 1 );
				extremes--;
			}
			
			return values;
		}
		
	}
}