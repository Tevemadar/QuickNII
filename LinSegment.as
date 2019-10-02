package {
	public class LinSegment {
		private var _x1:Number;
		private var _y1:Number;
		private var _x2:Number;
		private var _y2:Number;

		public function LinSegment(x1:Number,y1:Number,x2:Number,y2:Number) {
			_x1=x1;
			_y1=y1;
			_x2=x2;
			_y2=y2;
		}

		public function get(x:Number):Number {
			return _y1+(x-_x1)*(_y2-_y1)/(_x2-_x1);
		}
	}
}
