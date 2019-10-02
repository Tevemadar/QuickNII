package
{
	import flash.net.Socket;

	public class QS_Item
	{
		private var i:int;
		private var v:Volume;
		public var suffix:String;
		public var lm:SliceData;
		public function QS_Item(i:int,v:Volume,suffix:String,lm:SliceData)
		{
			this.i=i;
			this.v=v;
			this.suffix=suffix;
			this.lm=lm;
		}
		
		public function request(fsock:Socket):void{
//			var ul:Number=Math.sqrt(lm._ux*lm._ux+lm._uy*lm._uy+lm._uz*lm._uz);
//			var vl:Number=Math.sqrt(lm._vx*lm._vx+lm._vy*lm._vy+lm._vz*lm._vz);
//			lm._ux/=ul;lm._uy/=ul;lm._uz/=ul;
//			lm._vx/=vl;lm._vy/=vl;lm._vz/=vl;
//			var uu:Number=lm._urate*lm.width;
//			var ux:Number=lm._ux*uu;
//			var uy:Number=lm._uy*uu;
//			var uz:Number=lm._uz*uu;
//			var vv:Number=lm._vrate*lm.height;
//			var vx:Number=lm._vx*vv;
//			var vy:Number=lm._vy*vv;
//			var vz:Number=lm._vz*vv;
//			var ox:Number=lm._mx-(ux+vx)/2;
//			var oy:Number=lm._my-(uy+vy)/2;
//			var oz:Number=lm._mz-(uz+vz)/2;
//			
//			fsock.writeByte(i);
//			fsock.writeFloat(0);
//			fsock.writeFloat(65535);
//			fsock.writeDouble(ox);
//			fsock.writeDouble(oy);
//			fsock.writeDouble(oz);
//			fsock.writeDouble(ux);
//			fsock.writeDouble(uy);
//			fsock.writeDouble(uz);
//			fsock.writeDouble(vx);
//			fsock.writeDouble(vy);
//			fsock.writeDouble(vz);
//			fsock.flush();
		}
	}
}
