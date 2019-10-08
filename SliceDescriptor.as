package {
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLVariables;

	public class SliceDescriptor {
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
		public function CommitChanges():void {
			if(!changed)return;
			undopoint++;
			undostack[undopoint]=params.clone();
			stacksize=undopoint+1;
			changed=false;
			steptype=0;
		}

		public function StopRedo():void {
			stacksize=undopoint+1;
		}

		public function canUndo():Boolean{return undopoint>0/* || changed*/;} // todo
		public function Undo():void {
			CommitChanges();
			if(undopoint<=0)return;
			undopoint--;
			params=undostack[undopoint].clone();
			changed=false;
			Dispatch();
		}

		public function canRedo():Boolean{return undopoint<stacksize-1;}
		public function Redo():void {
			if(undopoint>=stacksize-1)return;
			undopoint++;
			params=undostack[undopoint].clone();
			changed=false;
			Dispatch();
		}

		private var _o:Vector3D;
		private var _u:Vector3D;
		private var _v:Vector3D;

		private var dispatch:Function;
		public function Dispatch():void { //!! todo: review surplus usages
			UpdateCorners();
			dispatch();
		}

		public function BuildRotation(cfg:String,t1:Number,t2:Number,t3:Number):void {
			const data:Vector.<Number>=params.rotation.rawData;
			if(cfg=="Coronal") {
				data[0]=1;data[1]=0;data[2]=0;
				data[4]=0;data[5]=0;data[6]=-1;
			} else if(cfg=="Sagittal") {
				data[0]=0;data[1]=1;data[2]=0;
				data[4]=0;data[5]=0;data[6]=-1;
			} else if(cfg=="Horizontal") {
				data[0]=0;data[1]=1;data[2]=0;
				data[4]=-1;data[5]=0;data[6]=0;
			}
			calcN(data);
			params.rotation.rawData=data;
			if(cfg=="Coronal") {
				if(!isNaN(t1))params.rotation.appendRotation(t1,Vector3D.X_AXIS);
				if(!isNaN(t2))params.rotation.appendRotation(t2,Vector3D.Z_AXIS);
				if(!isNaN(t3))params.rotation.appendRotation(t3,params.rotation.transformVector(Vector3D.Z_AXIS));
			} else if(cfg=="Sagittal") {
				if(!isNaN(t1))params.rotation.appendRotation(-t1,Vector3D.Y_AXIS);
				if(!isNaN(t2))params.rotation.appendRotation(t2,Vector3D.Z_AXIS);
				if(!isNaN(t3))params.rotation.appendRotation(t3,params.rotation.transformVector(Vector3D.Z_AXIS));
			} else if(cfg=="Horizontal") {
				if(!isNaN(t1))params.rotation.appendRotation(-t1,Vector3D.Y_AXIS);
				if(!isNaN(t2))params.rotation.appendRotation(t2,Vector3D.X_AXIS);
				if(!isNaN(t3))params.rotation.appendRotation(t3,params.rotation.transformVector(Vector3D.Z_AXIS));
			}
			changed=true;
		}

		private function UpdateCorners():void {
			var hu:Vector3D=new Vector3D(0.5,0,0);
			var hv:Vector3D=new Vector3D(0,0.5,0);

			hu=params.rotation.transformVector(hu);
			hu.scaleBy(params.width);
			hv=params.rotation.transformVector(hv);
			hv.scaleBy(params.height);

			_o=params.position.subtract(hu).subtract(hv);
			hu.scaleBy(2);
			hv.scaleBy(2);
			_u=hu;
			_v=hv;
			
		}

		public function get midpoint():Vector3D{return params.position;}
		public function get o():Vector3D{return _o;}
		public function get u():Vector3D{return _u;}
		public function get v():Vector3D{return _v;}

		public function init(xdim:int,ydim:int,zdim:int):void {
			const data:Vector.<Number>=params.rotation.rawData;
			
			params.position.x=xdim/2;
			params.position.y=ydim/2;
			params.position.z=zdim/2;
			params.width=xdim;
			params.height=zdim;
			data[0]=1;data[1]=0;data[2]=0;
			data[4]=0;data[5]=0;data[6]=-1;
			
			calcN(data);
			params.rotation.rawData=data;
			
			changed=true;
			CommitChanges();
			Dispatch();
		}
		
		public function load(anchoring:Vector.<Number>):void {
			const data:Vector.<Number>=params.rotation.rawData;
			
			var ox:Number=anchoring[0];
			var oy:Number=anchoring[1];
			var oz:Number=anchoring[2];
			var ux:Number=anchoring[3];
			var uy:Number=anchoring[4];
			var uz:Number=anchoring[5];
			var vx:Number=anchoring[6];
			var vy:Number=anchoring[7];
			var vz:Number=anchoring[8];
			
			data[0]=ux;data[1]=uy;data[2]=uz;
			data[4]=vx;data[5]=vy;data[6]=vz;
			params.width=unitvector(data,0);
			params.height=unitvector(data,1);
			params.position.x=ox+(ux-vx)/2;
			params.position.y=oy+(uy-vy)/2;
			params.position.z=oz+(uz-vz)/2;
			
			calcN(data);
			params.rotation.rawData=data;
			
			changed=true;
			CommitChanges();
			Dispatch();
		}
		
		public function get width():Number{return params.width;}
		public function set width(w:Number):void {
			if(params.width==w)return;
			params.width=w;
			changed=true;
		}

		public function get height():Number{return params.height;}
		public function set height(h:Number):void {
			if(params.height==h)return;
			params.height=h;
			changed=true;
		}

		public function get x():Number{return params.position.x;}
		public function get y():Number{return params.position.y;}
		public function get z():Number{return params.position.z;}
		public function setlocation(x:Number,y:Number,z:Number,d:Boolean=true):void {
			CommitChanges();
			params.position.x=x;
			params.position.y=y;
			params.position.z=z;
			changed=true;
			CommitChanges();
			if(d)Dispatch();
		}

		public function SliceDescriptor(dispatchCut:Function) {
			dispatch=dispatchCut;
		}

		private function get base():SliceParams {return undostack[undopoint];}

		public function BaseShift(plane:String,shift1:Number,shift2:Number):void {
			params.position[plane.charAt(0)]=base.position[plane.charAt(0)]+shift1;
			params.position[plane.charAt(1)]=base.position[plane.charAt(1)]+shift2;
			changed=true;
			Dispatch();
		}

		public function BaseRotate(plane:String,angle:Number):void {
			params.rotation=base.rotation.clone();
			params.rotation.appendRotation(angle,Vector3D[plane.charAt(2).toUpperCase()+"_AXIS"]);
			changed=true;
			Dispatch();
		}

		public function UVShift(u:Number,v:Number):void {
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

		public function UVStep(u:int,v:int):void {
			if(steptype!=STEP_UVSHIFT)CommitChanges();
			steptype=STEP_UVSHIFT;
			UVShift(u*shiftstep,v*shiftstep);
		}

		public function UVRot(fi:Number):void {
			var axis:Vector3D=new Vector3D(0,0,1);
			params.rotation.appendRotation(fi,params.rotation.transformVector(axis));
			changed=true;
			Dispatch();
		}

		public function UVStepRot(step:int):void {
			if(steptype!=STEP_UVROT)CommitChanges();
			steptype=STEP_UVROT;
			UVRot(step*rotstep);
		}

		public var shiftstep:Number=1;
		public function Shift(plane:String,dir1:int,dir2:int):void {
			if(steptype!=STEP_SHIFT)CommitChanges();
			steptype=STEP_SHIFT;
			params.position[plane.charAt(0)]+=shiftstep*dir1;
			params.position[plane.charAt(1)]+=shiftstep*dir2;
			changed=true;
			Dispatch();
		}

		public var rotstep:Number=1;
		public function Rotate(plane:String,dir:int):void {
			if(steptype!=STEP_ROT)CommitChanges();
			steptype=STEP_ROT;
			params.rotation.appendRotation(rotstep*dir,Vector3D[plane.charAt(2).toUpperCase()+"_AXIS"]);
			changed=true;
			Dispatch();
		}

		public static function calcN(data:Vector.<Number>):void {
			data[ 8]=data[1]*data[6]-data[2]*data[5];
			data[ 9]=data[2]*data[4]-data[0]*data[6];
			data[10]=data[0]*data[5]-data[1]*data[4];
		}

		private static function unitvector(data:Vector.<Number>,idx:uint):Number {
			idx*=4;
			const l:Number=Math.sqrt(data[idx]*data[idx]+data[idx+1]*data[idx+1]+data[idx+2]*data[idx+2]);
			data[idx]/=l;
			data[idx+1]/=l;
			data[idx+2]/=l;
			return l;
		}
	}
}
