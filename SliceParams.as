package
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class SliceParams
	{
		public var position:Vector3D=new Vector3D;
		public var rotation:Matrix3D=new Matrix3D;
		public var width:Number;
		public var height:Number;
		
		public function clone():SliceParams
		{
			// todo:normalize
			const ret:SliceParams=new SliceParams;
			ret.position=position.clone();
			ret.rotation=rotation.clone();
			ret.width=width;
			ret.height=height;
			return ret;
		}
	}
}