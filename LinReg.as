package
{
	public class LinReg
	{
		private var Sx:Number=0;
		private var Sy:Number=0;
		private var Sxy:Number=0;
		private var Sxx:Number=0;
		private var n:uint=0;
		
		public function add(x:Number,y:Number):void
		{
			n++;
			Sx+=x;
			Sy+=y;
			Sxy+=x*y;
			Sxx+=x*x;
		}
		
		private var _n:uint=0;
		private var _a:Number=0;
		private var _b:Number=0;
//		private function ab():void
//		{
//			if(_n!=n)
//			{
//				if(n==1)
//					_b=0;
//				else
//					_b=(n*Sxy-Sx*Sy)/(n*Sxx-Sx*Sx);
//				_a=Sy/n-_b*Sx/n;
//				_n=n;
//			}
//		}
//		
//		public function get a():Number
//		{
//			ab();
//			return _a;
//		}
//		public function get b():Number
//		{
//			ab();
//			return _b;
//		}
		
		public function get(x:Number):Number
		{
			if(_n!=n)
			{
				if(n==1)
					_b=0;
				else
					_b=(n*Sxy-Sx*Sy)/(n*Sxx-Sx*Sx);
				_a=Sy/n-_b*Sx/n;
				_n=n;
			}
			return _a+_b*x;
		}
	}
}