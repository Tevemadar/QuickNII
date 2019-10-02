package {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;

	public class SliceData extends EventDispatcher {
		public var sno:int;
		public var width:int;
		public var height:int;
		public var filename:String;
		private var _hasanchoring:Boolean;
		public function get hasanchoring():Boolean {return _hasanchoring;}
		public var packed:Vector.<Number>;
		public var unpacked:Vector.<Number>;

		public function get _mx():Number {return unpacked[0];}
		public function get _my():Number {return unpacked[1];}
		public function get _mz():Number {return unpacked[2];}
		public function get _ux():Number {return unpacked[3];}
		public function get _uy():Number {return unpacked[4];}
		public function get _uz():Number {return unpacked[5];}
		public function get _vx():Number {return unpacked[6];}
		public function get _vy():Number {return unpacked[7];}
		public function get _vz():Number {return unpacked[8];}
		public function get _urate():Number {return unpacked[9];}
		public function get _vrate():Number {return unpacked[10];}

		public function SliceData(filename:String,sno:int,width:int,height:int,anchoring:Vector.<Number>) {
			this.filename=filename;
			this.sno=sno;
			this.width=width;
			this.height=height;
			if(anchoring!=null)
				setPacked(anchoring);
		}

		public function setPacked(anchoring:Vector.<Number>):void {
			packed=anchoring;
			unpack();
			_hasanchoring=true;
		}

		public function unpack():void {
			unpacked=packed.slice();
			for(var i:int=0;i<3;i++)
				unpacked[i]+=(unpacked[i+3]+unpacked[i+6])/2;
			unpacked.push(normalize(3)/width,normalize(6)/height);
			orthonormalize();
		}

		public function setUnpacked(anchoring:Vector.<Number>):void {
			unpacked=anchoring;
			_hasanchoring=false;
			pack();
		}

		public function pack():Vector.<Number>
		{
			if(!hasanchoring){
				packed=unpacked.slice(0,9);
				const v:Number=unpacked[10];
				const u:Number=unpacked[9];
				for(var i:int=0;i<3;i++) {
					packed[i+3]*=u*width;
					packed[i+6]*=v*height;
					packed[i]-=(packed[i+3]+packed[i+6])/2;
				}
			}
			return packed;
		}

		public function clear():void {
			_hasanchoring=false;
			packed=unpacked=null;
		}

		private function normalize(idx:int):Number {
			var len:Number=0;
			for(var i:int=0;i<3;i++)
				len+=unpacked[idx+i]*unpacked[idx+i];
			len=Math.sqrt(len);
			for(i=0;i<3;i++)
				unpacked[idx+i]/=len;
			return len;
		}

		private function orthonormalize():void {
			normalize(3);
			var dot:Number=0;
			for(var i:int=0;i<3;i++)
				dot+=unpacked[i+3]*unpacked[i+6];
			for(i=0;i<3;i++)
				unpacked[i+6]-=unpacked[i+3]*dot;
			normalize(6);
		}
	}
}