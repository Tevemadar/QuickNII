package
{
	public class LandmarkSegment
	{
		private var _mx:LinSegment;
		private var _my:LinSegment;
		private var _mz:LinSegment;
		private var _ux:LinSegment;
		private var _uy:LinSegment;
		private var _uz:LinSegment;
		private var _vx:LinSegment;
		private var _vy:LinSegment;
		private var _vz:LinSegment;
		private var _urate:LinSegment;
		private var _vrate:LinSegment;
		
		public function LandmarkSegment(l1:Landmark,l2:Landmark,r:LandmarkLinReg,s:Number)
		{
			if(r==null)
			{
				_mx=new LinSegment(l1.sno,l1._mx,l2.sno,l2._mx);
				_my=new LinSegment(l1.sno,l1._my,l2.sno,l2._my);
				_mz=new LinSegment(l1.sno,l1._mz,l2.sno,l2._mz);
				_ux=new LinSegment(l1.sno,l1._ux,l2.sno,l2._ux);
				_uy=new LinSegment(l1.sno,l1._uy,l2.sno,l2._uy);
				_uz=new LinSegment(l1.sno,l1._uz,l2.sno,l2._uz);
				_vx=new LinSegment(l1.sno,l1._vx,l2.sno,l2._vx);
				_vy=new LinSegment(l1.sno,l1._vy,l2.sno,l2._vy);
				_vz=new LinSegment(l1.sno,l1._vz,l2.sno,l2._vz);
				_urate=new LinSegment(l1.sno,l1._urate,l2.sno,l2._urate);
				_vrate=new LinSegment(l1.sno,l1._vrate,l2.sno,l2._vrate);
			}
			else
			{
				const l:Landmark=l1==null?l2:l1;
				_mx=new LinSegment(l.sno,l._mx,s,r.mx(s));
				_my=new LinSegment(l.sno,l._my,s,r.my(s));
				_mz=new LinSegment(l.sno,l._mz,s,r.mz(s));
				_ux=new LinSegment(l.sno,l._ux,s,r.ux(s));
				_uy=new LinSegment(l.sno,l._uy,s,r.uy(s));
				_uz=new LinSegment(l.sno,l._uz,s,r.uz(s));
				_vx=new LinSegment(l.sno,l._vx,s,r.vx(s));
				_vy=new LinSegment(l.sno,l._vy,s,r.vy(s));
				_vz=new LinSegment(l.sno,l._vz,s,r.vz(s));
				_urate=new LinSegment(l.sno,l._urate,s,r.urate(s));
				_vrate=new LinSegment(l.sno,l._vrate,s,r.vrate(s));
			}
		}
		
		public function mx(sno:Number):Number{return _mx.y(sno);}
		public function my(sno:Number):Number{return _my.y(sno);}
		public function mz(sno:Number):Number{return _mz.y(sno);}
		public function ux(sno:Number):Number{return _ux.y(sno);}
		public function uy(sno:Number):Number{return _uy.y(sno);}
		public function uz(sno:Number):Number{return _uz.y(sno);}
		public function vx(sno:Number):Number{return _vx.y(sno);}
		public function vy(sno:Number):Number{return _vy.y(sno);}
		public function vz(sno:Number):Number{return _vz.y(sno);}
		public function urate(sno:Number):Number{return _urate.y(sno);}
		public function vrate(sno:Number):Number{return _vrate.y(sno);}
	}
}