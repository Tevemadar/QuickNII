package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;

	public class Landmark extends EventDispatcher
	{
		//   <slice filename='23-388_12_s154_20x.jpg' nr='154' width='12273' height='7488' comment='Whatever3' anchoring=''/> 
		[Bindable] public var description:String;
		[Bindable] public var sno:int;
		public var width:int;
		public var height:int;
		public var filename:String;
		public var anchoring:String;
		public var hasanchoring:Boolean;
		
		public var _mx:Number=0;
		public var _my:Number=0;
		public var _mz:Number=0;
		public var _ux:Number=0;
		public var _uy:Number=0;
		public var _uz:Number=0;
		public var _vx:Number=0;
		public var _vy:Number=0;
		public var _vz:Number=0;
		public var _urate:Number=0;
		public var _vrate:Number=0;
//		public var _rot1:Number=0;
//		public var _rot2:Number=0;
//		
//		public var xspacing:Number=Number.NaN;
//		public var yspacing:Number=Number.NaN;
//		public var zspacing:Number=Number.NaN;
		
		[Bindable] public var checked:Boolean;
		
		public function Landmark(xml:XML)
		{
			description=URLDecode(xml.@comment);
			sno=xml.@nr;
			width=xml.@width;
			height=xml.@height;
			filename=xml.@filename;
			anchoring=xml.@anchoring;
			if(anchoring!=null)anchoring=anchoring.replace(/&amp;/g,"&");
			unpack();
		}
		
//		public function Landmark(mx:Number,my:Number,mz:Number,
//								 ux:Number,uy:Number,uz:Number,
//								 vx:Number,vy:Number,vz:Number,
//								 urate:Number,vrate:Number)
//		{
//			_mx=mx;_my=my;_mz=mz;
//			_ux=ux;_uy=uy;_uz=uz;
//			_vx=vx;_vy=vy;_vz=vz;
//			_urate=urate;_vrate=vrate;
//		}
		
		public function pack():Array
		{
			const ul:Number=Math.sqrt(_ux*_ux+_uy*_uy+_uz*_uz);
			const vl:Number=Math.sqrt(_vx*_vx+_vy*_vy+_vz*_vz);
			_ux/=ul;_uy/=ul;_uz/=ul;
			_vx/=vl;_vy/=vl;_vz/=vl;
			const u:Number=_urate*width;
			const ux:Number=_ux*u;
			const uy:Number=_uy*u;
			const uz:Number=_uz*u;
			const v:Number=_vrate*height;
			const vx:Number=_vx*v;
			const vy:Number=_vy*v;
			const vz:Number=_vz*v;
			const ox:Number=_mx-(ux+vx)/2;
			const oy:Number=_my-(uy+vy)/2;
			const oz:Number=_mz-(uz+vz)/2;
			anchoring=
				  "ox="+ox+"&oy="+oy+"&oz="+oz
				+"&ux="+ux+"&uy="+uy+"&uz="+uz
				+"&vx="+vx+"&vy="+vy+"&vz="+vz;
			return [ox,oy,oz,ux,uy,uz,vx,vy,vz];
		}
		
		public function unpack():void
		{
			if(anchoring!=null && anchoring!="")
			{
				const urlvar:URLVariables=new URLVariables(anchoring);
				if(    urlvar.hasOwnProperty("ox") && urlvar.hasOwnProperty("oy") && urlvar.hasOwnProperty("oz")
				    && urlvar.hasOwnProperty("ux") && urlvar.hasOwnProperty("uy") && urlvar.hasOwnProperty("uz")
				    && urlvar.hasOwnProperty("vx") && urlvar.hasOwnProperty("vy") && urlvar.hasOwnProperty("vz"))
				{
					_ux=parseFloat(urlvar.ux);_uy=parseFloat(urlvar.uy);_uz=parseFloat(urlvar.uz);
					_vx=parseFloat(urlvar.vx);_vy=parseFloat(urlvar.vy);_vz=parseFloat(urlvar.vz);
					_mx=parseFloat(urlvar.ox)+(_ux+_vx)/2;
					_my=parseFloat(urlvar.oy)+(_uy+_vy)/2;
					_mz=parseFloat(urlvar.oz)+(_uz+_vz)/2;
					const u:Number=Math.sqrt(_ux*_ux+_uy*_uy+_uz*_uz);
					const v:Number=Math.sqrt(_vx*_vx+_vy*_vy+_vz*_vz);
					_ux/=u;_uy/=u;_uz/=u;
					_vx/=v;_vy/=v;_vz/=v;
					_urate=u/width;
					_vrate=v/height;
					hasanchoring=true;
				}
			}
		}
		
		public function URLDecode(s:String):String
		{
			return unescape(s.replace(/\+/g," "));
		}
	}
}