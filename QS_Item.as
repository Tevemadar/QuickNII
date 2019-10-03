package {
	import flash.net.Socket;

	public class QS_Item {
		private var i:int;
		private var v:Volume;
		public var suffix:String;
		public var lm:SliceData;
		public function QS_Item(i:int,v:Volume,suffix:String,lm:SliceData) {
			this.i=i;
			this.v=v;
			this.suffix=suffix;
			this.lm=lm;
		}

		public function request(fsock:Socket):void {
			fsock.writeByte(i);
			fsock.writeFloat(0);
			fsock.writeFloat(65535);
			for(var i:int=0;i<9;i++)
				fsock.writeDouble(lm.packed[i]);
			fsock.flush();
		}
	}
}
