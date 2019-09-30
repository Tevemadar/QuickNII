package
{
	public class LandmarkLinReg
	{
		private var _mx:LinReg=new LinReg;
		private var _my:LinReg=new LinReg;
		private var _mz:LinReg=new LinReg;
		private var _ux:LinReg=new LinReg;
		private var _uy:LinReg=new LinReg;
		private var _uz:LinReg=new LinReg;
		private var _vx:LinReg=new LinReg;
		private var _vy:LinReg=new LinReg;
		private var _vz:LinReg=new LinReg;
		private var _urate:LinReg=new LinReg;
		private var _vrate:LinReg=new LinReg;
		
		public function update(l:Landmark):void
		{
			_mx.add(l.sno,l._mx);
			_my.add(l.sno,l._my);
			_mz.add(l.sno,l._mz);
			_ux.add(l.sno,l._ux);
			_uy.add(l.sno,l._uy);
			_uz.add(l.sno,l._uz);
			_vx.add(l.sno,l._vx);
			_vy.add(l.sno,l._vy);
			_vz.add(l.sno,l._vz);
			_urate.add(l.sno,l._urate);
			_vrate.add(l.sno,l._vrate);
		}

//		public function updateExplicit(mx:Number,my:Number,mz:Number,
//                               ux:Number,uy:Number,uz:Number,
//                               vx:Number,vy:Number,vz:Number,
//                               urate:Number,vrate:Number,
//                               sno:Number):void
//		{
//			_mx.add(sno,mx);
//			_my.add(sno,my);
//			_mz.add(sno,mz);
//			_ux.add(sno,ux);
//			_uy.add(sno,uy);
//			_uz.add(sno,uz);
//			_vx.add(sno,vx);
//			_vy.add(sno,vy);
//			_vz.add(sno,vz);
//			_urate.add(sno,urate);
//			_vrate.add(sno,vrate);
//		}
		
		public function mx(sno:Number):Number{return _mx.get(sno);}
		public function my(sno:Number):Number{return _my.get(sno);}
		public function mz(sno:Number):Number{return _mz.get(sno);}
		public function ux(sno:Number):Number{return _ux.get(sno);}
		public function uy(sno:Number):Number{return _uy.get(sno);}
		public function uz(sno:Number):Number{return _uz.get(sno);}
		public function vx(sno:Number):Number{return _vx.get(sno);}
		public function vy(sno:Number):Number{return _vy.get(sno);}
		public function vz(sno:Number):Number{return _vz.get(sno);}
		public function urate(sno:Number):Number{return _urate.get(sno);}
		public function vrate(sno:Number):Number{return _vrate.get(sno);}
	}
}