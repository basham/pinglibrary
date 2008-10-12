package org.pingplatform.ping.utils {
	
	public class Normalize {
		
		public static const MEAN:String = "normalizeMean";
		public static const LINEAR:String = "normalizeLinear";
		public static const QUADRATIC:String = "normalizeQuadratic";
		
		// Average would be the mathematical equivalent of statistical normalizing
		public static function Average( values:Array, averageType:String = MEAN, truncateExtremes:Boolean = false, truncatePercentage:Number = .25 ):uint {
			// Removes Extremes from array
			if ( truncateExtremes )
				values = ArrayUtil.TruncateExtremes( values, truncatePercentage );
			// Returns Average based on Type
			switch( averageType ) {
				case LINEAR:
					return Linear( values );
				case QUADRATIC:
					return Quadratic( values );
				case MEAN:
				default:
					return Mean( values );
			}
		}
		
		// Arithmetic Mean
		public static function Mean( values:Array ):uint {
			var normal:uint = 0;
			for( var i:uint = 0; i < values.length; i++ )
				normal += values[ i ];
			normal /= values.length;
			return normal;
		}
		
		// Weighted Linear Mean
		public static function Linear( values:Array ):uint {
			var normal:uint = 0, weight:uint = 0;
			for( var i:uint = 0, n:uint = values.length; i < values.length; i++, n-- ) {
				normal += values[ i ] * n;
				weight += n;
			}
			normal /= weight;
			return normal;
		}

		// Weighted Quadratic Mean
		public static function Quadratic( values:Array ):uint {
			var normal:uint = 0, weight:uint = 0;
			for( var i:uint = 0, n:uint = values.length, q:uint = 0; i < values.length; i++, n-- ) {
				q = n * n;
				normal += values[ i ] * q;
				weight += q;
			}
			normal /= weight;
			return normal;
		}
		
	}
}