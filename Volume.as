package
{
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;

	public class Volume
	{
		public var name:String;
//		public var id:String;
//		public var datatype:String;
//		public var datasize:int;
//		public var bigendian:Boolean;
		public var type:int;
		public var minval:Number;
		public var maxval:Number;
		
		public var colors:Vector.<uint>=null;
		public var names:Vector.<String>=null;

//		public function Volume(node:XML,xdim:int,ydim:int,zdim:int)
		public function Volume(config:Socket)
		{
			type=config.readByte();
			name=config.readUTF();
			switch(type)
			{
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
					for(var i:int=0;i<items;i++)
					{
						colors.push(config.readUnsignedInt());
						names.push(config.readUTF());
					}
					break;
				case 5:
					break;
				default:
					trace("type?");
			}
			
//			name=URLDecode(node.@name);
//			id=URLDecode(node.@id);
//			datatype=node.@datatype;
//			var i:int=datatype.length-1;
//			while(datatype.charCodeAt(i)>=0x30 && datatype.charCodeAt(i)<=0x39)i--;
//			datasize=Number(datatype.substr(i+1))/8;
//			bigendian=node.@bigendian.match(/true/i);
//			minval=node.@minval;
//			maxval=node.@maxval;
//	
//			const labels:XMLList=node.label;
//			if(labels.length()>0)
//			{
//				sparsepalette=new SparsePalette;
//				for each (var label:XML in labels)
//					sparsepalette.put(label.@index,new PaletteItem(URLDecode(label.@text),label.@r,label.@g,label.@b));
//			}
		}
		
		public var parammin:Number;
		public var parammax:Number;
		public var gray:Boolean=true;
	}
}
