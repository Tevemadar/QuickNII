package {
	import flash.net.Socket;
	import flash.utils.ByteArray;

	import mx.utils.Base64Decoder;

	public class Volume {
		public var name:String;
		public var type:int;
		public var minval:Number;
		public var maxval:Number;

		public var colors:Vector.<uint>=null;
		public var names:Vector.<String>=null;

		public function Volume(config:Socket) {
			type=config.readByte();
			name=config.readUTF();
			switch(type) {
				case 1:
				case 2:
					minval=config.readDouble();
					maxval=config.readDouble();
					break;
				case 3:
				case 4:
					const items:int=config.readUnsignedShort();
					colors=new Vector.<uint>;
					names=new Vector.<String>;
					for(var i:int=0;i<items;i++) {
						colors.push(config.readUnsignedInt());
						names.push(config.readUTF());
					}
					break;
				case 5:
					break;
				default:
					trace("type?");
			}
		}

		public var parammin:Number;
		public var parammax:Number;
		public var gray:Boolean=true;
	}
}
