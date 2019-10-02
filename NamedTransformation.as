package {
	public class NamedTransformation {
		public const xrow:Vector.<Number>=new Vector.<Number>;
		public const yrow:Vector.<Number>=new Vector.<Number>;
		public const zrow:Vector.<Number>=new Vector.<Number>;
		[Bindable] public var name:String;
		[Bindable] public var selected:Boolean=true;

		public static var hackedScale:Number=1;

		public function NamedTransformation(name:String,
											x0:Number,x1:Number,x2:Number,x3:Number,
											y0:Number,y1:Number,y2:Number,y3:Number,
											z0:Number,z1:Number,z2:Number,z3:Number) {
			this.name=name;
			xrow.push(x0,x1,x2,x3);
			yrow.push(y0,y1,y2,y3);
			zrow.push(z0,z1,z2,z3);

			var det:Number=
				x0*(y1*z2-z1*y2)
			   -x1*(y0*z2-z0*y2)
			   +x2*(y0*z1-z0*y1);

			xinv.push( (y1*z2-z1*y2)/det,-(x1*z2-z1*x2)/det, (x1*y2-y1*x2)/det);
			yinv.push(-(y0*z2-z0*y2)/det, (x0*z2-z0*x2)/det,-(x0*y2-y0*x2)/det);
			zinv.push( (y0*z1-z0*y1)/det,-(x0*z1-z0*x1)/det, (x0*y1-y0*x1)/det);

			if((x0!=0) && (x0!=1))hackedScale=x0;
		}

		public const xinv:Vector.<Number>=new Vector.<Number>;
		public const yinv:Vector.<Number>=new Vector.<Number>;
		public const zinv:Vector.<Number>=new Vector.<Number>;

		public function get voxx():Number{
			return (x-xrow[3])*xinv[0]+(y-yrow[3])*xinv[1]+(z-zrow[3])*xinv[2];
		}
		public function get voxy():Number{
			return (x-xrow[3])*yinv[0]+(y-yrow[3])*yinv[1]+(z-zrow[3])*yinv[2];
		}
		public function get voxz():Number{
			return (x-xrow[3])*zinv[0]+(y-yrow[3])*zinv[1]+(z-zrow[3])*zinv[2];
		}

		public function setVox(x:Number,y:Number,z:Number):void {
			this.x=x*xrow[0]+y*xrow[1]+z*xrow[2]+xrow[3];
			this.y=x*yrow[0]+y*yrow[1]+z*yrow[2]+yrow[3];
			this.z=x*zrow[0]+y*zrow[1]+z*zrow[2]+zrow[3];
		}

		[Bindable] public var x:Number;
		[Bindable] public var y:Number;
		[Bindable] public var z:Number;
	}
}
