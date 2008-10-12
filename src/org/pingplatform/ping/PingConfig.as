package org.pingplatform.ping {

	import org.pingplatform.ping.utils.Normalize;
	
	public class PingConfig {
		
		public static const ADDRESS:String = 'localhost';
		public static const PORT:uint = 5001;
		public static const PASSWORD:String = '';
		
		public static const SENSOR_SENSITIVITY:uint = 0;
		public static const SENSOR_SMOOTHING:uint = 20;
		public static const SENSOR_TRUNCATE_PERCENTAGE:Number = 0;
		public static const SENSOR_NORMALIZATION_ALGORITHM:String = Normalize.QUADRATIC;
		public static const MIN_ATTACHED_SENSOR_VALUE:uint = 1;
		public static const MIN_PERCENTAGE_VALUE:uint = 650;
		
		public static const CALIBRATION_MAX_RAW_VALUE:uint = 530;
		public static const CALIBRATION_MIN_SUCCESSFUL_ATTEMPTS:uint = 100;
		public static const CALIBRATION_SKIP_INTERVAL:uint = 10;
		public static const CALIBRATION_BUFFER:uint = 20;
		
		
		// 10" 450
		// 11" 400
		// 13" 350
		// 15" 300
		// 18" 250
		// 22" 200
		// 26" 150
		// 30" 100
		// 38" 50
		// 43" 20
		//
		// y = 49.55 + -.82 * x^.69 + .00055 * x^1.69
		// -- OR SIMPLER --
		// y = .00016 * x^2 + -.15 * x + 44.98
		//
		
	}
}