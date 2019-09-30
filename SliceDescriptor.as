package
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLVariables;

	public class SliceDescriptor
	{
		private var params:SliceParams=new SliceParams;
		private var changed:Boolean=false;
		
		private var undostack:Vector.<SliceParams>=new Vector.<SliceParams>;
		private var undopoint:int=-1;
		private var stacksize:int=0;
		
		private const STEP_SHIFT:int=1;
		private const STEP_ROT:int=2;
		private const STEP_UVSHIFT:int=3;
		private const STEP_UVROT:int=4;
		private var steptype:int=0;
		public function CommitChanges():void
		{
			if(!changed)return;
			undopoint++;
			undostack[undopoint]=params.clone();
			stacksize=undopoint+1;
			changed=false;
			steptype=0;
		}
		
		public function StopRedo():void
		{
			stacksize=undopoint+1;
		}
		
		public function canUndo():Boolean{return undopoint>0/* || changed*/;} // todo
		public function Undo():void
		{
			CommitChanges();
			if(undopoint<=0)return;
			undopoint--;
			params=undostack[undopoint].clone();
			changed=false;
			Dispatch();
		}
		
		public function canRedo():Boolean{return undopoint<stacksize-1;}
		public function Redo():void
		{
			if(undopoint>=stacksize-1)return;
			undopoint++;
			params=undostack[undopoint].clone();
			changed=false;
			Dispatch();
		}
		
		private var _topleft:Vector3D;
		private var _topright:Vector3D;
		private var _bottomleft:Vector3D;
		private var _bottomright:Vector3D;
		
		private var dispatch:Function;
		public function Dispatch():void //!! todo: review surplus usages
		{
			UpdateCorners();
			dispatch();
		}
		
		public function BuildRotation(cfg:String,t1:Number,t2:Number,t3:Number):void
		{
			const data:Vector.<Number>=params.rotation.rawData;
			if(cfg=="Coronal")
			{
				data[0]=1;data[1]=0;data[2]=0;
				data[4]=0;data[5]=0;data[6]=-1;
			}
			else if(cfg=="Sagittal")
			{
				data[0]=0;data[1]=1;data[2]=0;
				data[4]=0;data[5]=0;data[6]=-1;
			}
			else if(cfg=="Horizontal")
			{
				data[0]=0;data[1]=1;data[2]=0;
				data[4]=-1;data[5]=0;data[6]=0;
			}
			calcN(data);
			params.rotation.rawData=data;
			if(cfg=="Coronal")
			{
				if(!isNaN(t1))params.rotation.appendRotation(t1,Vector3D.X_AXIS);
				if(!isNaN(t2))params.rotation.appendRotation(t2,Vector3D.Z_AXIS);
				if(!isNaN(t3))params.rotation.appendRotation(t3,params.rotation.transformVector(Vector3D.Z_AXIS));
			}
			else if(cfg=="Sagittal")
			{
				if(!isNaN(t1))params.rotation.appendRotation(-t1,Vector3D.Y_AXIS);
				if(!isNaN(t2))params.rotation.appendRotation(t2,Vector3D.Z_AXIS);
				if(!isNaN(t3))params.rotation.appendRotation(t3,params.rotation.transformVector(Vector3D.Z_AXIS));
			}
			else if(cfg=="Horizontal")
			{
				if(!isNaN(t1))params.rotation.appendRotation(-t1,Vector3D.Y_AXIS);
				if(!isNaN(t2))params.rotation.appendRotation(t2,Vector3D.X_AXIS);
				if(!isNaN(t3))params.rotation.appendRotation(t3,params.rotation.transformVector(Vector3D.Z_AXIS));
			}
			changed=true;
		}
		
		private function UpdateCorners():void
		{
			var hu:Vector3D=new Vector3D(0.5,0,0);
			var hv:Vector3D=new Vector3D(0,0.5,0);
			
			hu=params.rotation.transformVector(hu);
			hu.scaleBy(params.width);
			hv=params.rotation.transformVector(hv);
			hv.scaleBy(params.height);
			
			_topleft=params.position.subtract(hu).subtract(hv);
			_topright=params.position.add(hu).subtract(hv);
			_bottomleft=params.position.subtract(hu).add(hv);
			_bottomright=params.position.add(hu).add(hv);
		}

		public function get midpoint():Vector3D{return params.position;}
		public function get topleft():Vector3D{return _topleft;}
		public function get topright():Vector3D{return _topright;}
		public function get bottomleft():Vector3D{return _bottomleft;}
		public function get bottomright():Vector3D{return _bottomright;}
		
		private var xdim:int;
		private var ydim:int;
		private var zdim:int;

		public function doInit(variables:URLVariables,xdim:int,ydim:int,zdim:int):void //!!
		{
			this.xdim=xdim;//...
			this.ydim=ydim;
			this.zdim=zdim;
			var ox:Number=parseFloat(variables.ox); // NAVI optional precise-positioning arguments are parsed here
			var oy:Number=parseFloat(variables.oy);
			var oz:Number=parseFloat(variables.oz);
			var ux:Number=parseFloat(variables.ux);
			var uy:Number=parseFloat(variables.uy);
			var uz:Number=parseFloat(variables.uz);
			var vx:Number=parseFloat(variables.vx);
			var vy:Number=parseFloat(variables.vy);
			var vz:Number=parseFloat(variables.vz);
			
			const data:Vector.<Number>=params.rotation.rawData;
			
			if(!isNaN(ox) && !isNaN(oy) && !isNaN(oz) &&
				!isNaN(ux) && !isNaN(uy) && !isNaN(uz) &&
				!isNaN(vx) && !isNaN(vy) && !isNaN(vz)) // NAVI precise-positioning happens only if all 9 components are provided 
			{
				//hack
				vy=-vy;
				vz=-vz;
				vx=-vx;
				
				if(ValueBox.flipxselected)
				{
					ox=xdim-ox;
					ux=-ux;
					vx=-vx;
				}
				if(ValueBox.flipyselected)
				{
					oy=ydim-oy;
					uy=-uy;
					vy=-vy;
				}
				if(ValueBox.flipzselected)
				{
					oz=zdim-oz;
					uz=-uz;
					vz=-vz;
				}
				
				data[0]=ux;data[1]=uy;data[2]=uz;
				data[4]=vx;data[5]=vy;data[6]=vz;
				params.width=unitvector(data,0);
				params.height=unitvector(data,1);
				params.position.x=ox+(ux-vx)/2;
				params.position.y=oy+(uy-vy)/2;
				params.position.z=oz+(uz-vz)/2;
			}
			else
			{
				const paramx:Number=parseFloat(variables.x); // NAVI optional rough positioning of x-slice (defaults to middle) 
				const paramy:Number=parseFloat(variables.y); // NAVI optional rough positioning of y-slice (defaults to middle)
				const paramz:Number=parseFloat(variables.z); // NAVI optional rough positioning of z-slice (defaults to middle)
				params.position.x=isNaN(paramx)?xdim/2:paramx;
				params.position.y=isNaN(paramy)?ydim/2:paramy;
				params.position.z=isNaN(paramz)?zdim/2:paramz;
				params.width=xdim;
				params.height=zdim;
				data[0]=1;data[1]=0;data[2]=0;
				data[4]=0;data[5]=0;data[6]=-1;
			}
			
			calcN(data);
			params.rotation.rawData=data;
			
			changed=true;
			CommitChanges();
			Dispatch();
		}

		public function get width():Number{return params.width;}
		public function set width(w:Number):void
		{
			if(params.width==w)return;
			params.width=w;
			changed=true;
		}
		public function get height():Number{return params.height;}
		public function set height(h:Number):void
		{
			if(params.height==h)return;
			params.height=h;
			changed=true;
		}
		public function setSize(w:Number,h:Number,d:Boolean=true):void
		{
			width=w;
			height=h
			if(d)Dispatch();
		}
		
		public function get x():Number{return params.position.x;}
		public function get y():Number{return params.position.y;}
		public function get z():Number{return params.position.z;}
		public function setlocation(x:Number,y:Number,z:Number,d:Boolean=true):void
		{
			CommitChanges();
			params.position.x=x;
			params.position.y=y;
			params.position.z=z;
			changed=true;
			CommitChanges();
			if(d)Dispatch();
		}
		
		public function SliceDescriptor(dispatchCut:Function)
		{
			dispatch=dispatchCut;
		}
		
		private function get base():SliceParams {return undostack[undopoint];}
		
		public function BaseShift(plane:String,shift1:Number,shift2:Number):void
		{
			params.position[plane.charAt(0)]=base.position[plane.charAt(0)]+shift1;
			params.position[plane.charAt(1)]=base.position[plane.charAt(1)]+shift2;
			changed=true;
			Dispatch();
		}
		
		public function BaseRotate(plane:String,angle:Number):void
		{
			params.rotation=base.rotation.clone();
			params.rotation.appendRotation(angle,Vector3D[plane.charAt(2).toUpperCase()+"_AXIS"]);
			changed=true;
			Dispatch();
		}
		
		public function UVShift(u:Number,v:Number):void
		{
			var hu:Vector3D=new Vector3D(u,0,0);
			var hv:Vector3D=new Vector3D(0,v,0);
			
			hu=params.rotation.transformVector(hu);
			hv=params.rotation.transformVector(hv);
			params.position.x+=hu.x+hv.x;
			params.position.y+=hu.y+hv.y;
			params.position.z+=hu.z+hv.z;
			changed=true;
			Dispatch();
		}
		
		public function UVStep(u:int,v:int):void
		{
			if(steptype!=STEP_UVSHIFT)CommitChanges();
			steptype=STEP_UVSHIFT;
			UVShift(u*shiftstep,v*shiftstep);
		}
		
		public function UVRot(fi:Number):void
		{
			var axis:Vector3D=new Vector3D(0,0,1);
			params.rotation.appendRotation(fi,params.rotation.transformVector(axis));
			changed=true;
			Dispatch();
		}
		
		public function UVStepRot(step:int):void
		{
			if(steptype!=STEP_UVROT)CommitChanges();
			steptype=STEP_UVROT;
			UVRot(step*rotstep);
		}
		
		public var shiftstep:Number=1;
		public function Shift(plane:String,dir1:int,dir2:int):void
		{
			if(steptype!=STEP_SHIFT)CommitChanges();
			steptype=STEP_SHIFT;
			params.position[plane.charAt(0)]+=shiftstep*dir1;
			params.position[plane.charAt(1)]+=shiftstep*dir2;
			changed=true;
			Dispatch();
		}
		
		public var rotstep:Number=1;
		public function Rotate(plane:String,dir:int):void
		{
			if(steptype!=STEP_ROT)CommitChanges();
			steptype=STEP_ROT;
			params.rotation.appendRotation(rotstep*dir,Vector3D[plane.charAt(2).toUpperCase()+"_AXIS"]);
			changed=true;
			Dispatch();
		}
		
		private static function Unitize(data:Vector.<Number>):void
		{
			for(var i:int=0;i<3;i++)
				unitvector(data,i);
		}
		
		public function rawdata():Vector.<Number>{return params.rotation.rawData;}
		
		public static function setUcheckVcalcN(data:Vector.<Number>,x:Number,y:Number,z:Number):void
		{
			data[0]=x;data[1]=y;data[2]=z;
			if(x!=0 && y==0 && z==0)
			{
				data[4]=0;
				if(data[5]==0 && data[6]==0) {data[5]=data[9];data[6]=data[10];}
			}
			if(x==0 && y!=0 && z==0)
			{
				data[5]=0;
				if(data[4]==0 && data[6]==0) {data[4]=data[8];data[6]=data[10];}
			}
			if(x==0 && y==0 && z!=0)
			{
				data[6]=0;
				if(data[4]==0 && data[5]==0) {data[4]=data[8];data[5]=data[9];}
			}
			calcN(data);
		}
		
		public static function setVcheckUcalcN(data:Vector.<Number>,x:Number,y:Number,z:Number):void
		{
			data[4]=x;data[5]=y;data[6]=z;
			if(x!=0 && y==0 && z==0)
			{
				data[0]=0;
				if(data[1]==0 && data[2]==0) {data[1]=data[9];data[2]=data[10];}
			}
			if(x==0 && y!=0 && z==0)
			{
				data[1]=0;
				if(data[0]==0 && data[2]==0) {data[0]=data[8];data[2]=data[10];}
			}
			if(x==0 && y==0 && z!=0)
			{
				data[2]=0;
				if(data[0]==0 && data[1]==0) {data[0]=data[8];data[1]=data[9];}
			}
			calcN(data);
		}
		
		public static function calcN(data:Vector.<Number>):void
		{
			data[ 8]=data[1]*data[6]-data[2]*data[5];
			data[ 9]=data[2]*data[4]-data[0]*data[6];
			data[10]=data[0]*data[5]-data[1]*data[4];
		}
		
		private static function unitvector(data:Vector.<Number>,idx:uint):Number
		{
			idx*=4;
			const l:Number=Math.sqrt(data[idx]*data[idx]+data[idx+1]*data[idx+1]+data[idx+2]*data[idx+2]);
			data[idx]/=l;
			data[idx+1]/=l;
			data[idx+2]/=l;
			return l;
		}
		
		public static function fixU(data:Vector.<Number>):void
		{
			const dot:Number=data[0]*data[4]+data[1]*data[5]+data[2]*data[6];
			data[0]-=dot*data[4];
			data[1]-=dot*data[5];
			data[2]-=dot*data[6];
			unitvector(data,0);
			calcN(data);
		}
		
		public static function fixV(data:Vector.<Number>):void
		{
			const dot:Number=data[0]*data[4]+data[1]*data[5]+data[2]*data[6];
			data[4]-=dot*data[0];
			data[5]-=dot*data[1];
			data[6]-=dot*data[2];
			unitvector(data,1);
			calcN(data);
		}
		
		public static function range(x:Number,y:Number=0):Boolean
		{
			if((x-y)<-0.00005 || (y-x)>0.00005)return false;
			return true;
		}
		
		public function magic(event:Event):void
		{
			CommitChanges();
			const data:Vector.<Number>=params.rotation.rawData;
			changed=true;
			switch(event.target.label)
			{
				case "U-X":setUcheckVcalcN(data,-1, 0, 0);params.width=xdim;break;
				case "U-Y":setUcheckVcalcN(data, 0,-1, 0);params.width=ydim;break;
				case "U-Z":setUcheckVcalcN(data, 0, 0,-1);params.width=zdim;break;
				case "U+X":setUcheckVcalcN(data, 1, 0, 0);params.width=xdim;break;
				case "U+Y":setUcheckVcalcN(data, 0, 1, 0);params.width=ydim;break;
				case "U+Z":setUcheckVcalcN(data, 0, 0, 1);params.width=zdim;break;
				case "V-X":setVcheckUcalcN(data,-1, 0, 0);params.height=xdim;break;
				case "V-Y":setVcheckUcalcN(data, 0,-1, 0);params.height=ydim;break;
				case "V-Z":setVcheckUcalcN(data, 0, 0,-1);params.height=zdim;break;
				case "V+X":setVcheckUcalcN(data, 1, 0, 0);params.height=xdim;break;
				case "V+Y":setVcheckUcalcN(data, 0, 1, 0);params.height=ydim;break;
				case "V+Z":setVcheckUcalcN(data, 0, 0, 1);params.height=zdim;break;
				case "uxy":
					if(range(0)&&range(1))changed=false;
					else
					{
						data[2]=0;
						unitvector(data,0);
						fixV(data);
					}
					break;
				case "uxz":
					if(range(0)&&range(2))changed=false;
					else
					{
						data[1]=0;
						unitvector(data,0);
						fixV(data);
					}
					break;
				case "uyz":
					if(range(1)&&range(2))changed=false;
					else
					{
						data[0]=0;
						unitvector(data,0);
						fixV(data);
					}
					break;
				case "vxy":
					if(range(4)&&range(5))changed=false;
					else
					{
						data[6]=0;
						unitvector(data,1);
						fixU(data);
					}
					break;
				case "vxz":
					if(range(4)&&range(6))changed=false;
					else
					{
						data[5]=0;
						unitvector(data,1);
						fixU(data);
					}
					break;
				case "vyz":
					if(range(5)&&range(6))changed=false;
					else
					{
						data[4]=0;
						unitvector(data,1);
						fixU(data);
					}
					break;
				default:
					changed=false;
			}
			if(changed)
			{
				Unitize(data);
				params.rotation.rawData=data;
				CommitChanges();
				Dispatch();
			}
		}
	}
}
