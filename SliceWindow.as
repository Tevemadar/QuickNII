package {
	import flash.events.Event;
	import flash.events.MouseEvent;

	import flexlib.mdi.containers.MDIWindow;

	import mx.controls.Button;

	public class SliceWindow extends MDIWindow {
		public var inner:Object;

		[Embed(source='icons/LeftArrow.png')]
		public static var ArrowLeft:Class;
		[Embed(source='icons/RightArrow.png')]
		public static var ArrowRight:Class;
		[Embed(source='icons/UpArrow.png')]
		public static var ArrowUp:Class;
		[Embed(source='icons/DownArrow.png')]
		public static var ArrowDown:Class;
		[Embed(source='icons/RotCCW.png')]
		public static var ArrowCCW:Class;
		[Embed(source='icons/RotCW.png')]
		public static var ArrowCW:Class;

		[Embed(source='icons/HSize.png')]
		public static var HSize:Class;
		[Embed(source='icons/VSize.png')]
		public static var VSize:Class;
//		[Embed(source='icons/FSize.png')]
//		public static var FSize:Class;
//		[Embed(source='icons/RotF.png')]
//		public static var RotF:Class;
		[Embed(source='icons/Drag.png')]
		public static var Drag:Class;

		protected var ButtonLeft:Button=new Button();
		protected var ButtonRight:Button=new Button();
		protected var ButtonUp:Button=new Button();
		protected var ButtonDown:Button=new Button();
		protected var ButtonCCW:Button=new Button();
		protected var ButtonCW:Button=new Button();

		protected var ButtonHS:Button=new Button();
		protected var ButtonVS:Button=new Button();
//		protected var ButtonFS:Button=new Button();
//		protected var ButtonRF:Button=new Button();
		protected var ButtonDrag:Button=new Button();

		override protected function createChildren():void {
			super.createChildren();
			ButtonLeft.width=ButtonRight.width=ButtonUp.width=ButtonDown.width=ButtonCCW.width=ButtonCW.width=22;
			ButtonLeft.height=ButtonRight.height=ButtonUp.height=ButtonDown.height=ButtonCCW.height=ButtonCW.height=22;
			ButtonHS.width=ButtonVS.width=/*ButtonFS.width=*//*ButtonRF.width=*/ButtonDrag.width=22;
			ButtonHS.height=ButtonVS.height=/*ButtonFS.height=*//*ButtonRF.height=*/ButtonDrag.height=22;
			ButtonLeft.setStyle("icon",ArrowLeft);
			ButtonLeft.addEventListener(MouseEvent.CLICK,inner.onLeft);
			ButtonRight.setStyle("icon",ArrowRight);
			ButtonRight.addEventListener(MouseEvent.CLICK,inner.onRight);
			ButtonUp.setStyle("icon",ArrowUp);
			ButtonUp.addEventListener(MouseEvent.CLICK,inner.onUp);
			ButtonDown.setStyle("icon",ArrowDown);
			ButtonDown.addEventListener(MouseEvent.CLICK,inner.onDown);
			ButtonCCW.setStyle("icon",ArrowCCW);
			ButtonCCW.addEventListener(MouseEvent.CLICK,inner.onCCW);
			ButtonCW.setStyle("icon",ArrowCW);
			ButtonCW.addEventListener(MouseEvent.CLICK,inner.onCW);
			ButtonHS.setStyle("icon",HSize);
			ButtonHS.toggle=true;
//			ButtonHS.addEventListener(MouseEvent.CLICK,inner.onHS);
			ButtonHS.addEventListener(Event.CHANGE,
				function():void {
					ButtonVS.selected=ButtonDrag.selected=false;
					ButtonHS.selected=true;
					inner.onHS();
				});
			ButtonVS.setStyle("icon",VSize);
			ButtonVS.toggle=true;
//			ButtonVS.addEventListener(MouseEvent.CLICK,inner.onVS);
			ButtonVS.addEventListener(Event.CHANGE,
				function():void {
					ButtonHS.selected=ButtonDrag.selected=false;
					ButtonVS.selected=true;
					inner.onVS();
				});
//			ButtonFS.setStyle("icon",FSize);
//			ButtonFS.addEventListener(MouseEvent.CLICK,inner.onFS);
//			ButtonRF.setStyle("icon",RotF);
//			ButtonRF.addEventListener(MouseEvent.CLICK,inner.onRF);
			ButtonDrag.setStyle("icon",Drag);
			ButtonDrag.toggle=ButtonDrag.selected=true;
//			ButtonDrag.addEventListener(MouseEvent.CLICK,inner.onDrag);
			ButtonDrag.addEventListener(Event.CHANGE,
				function():void {
					ButtonVS.selected=ButtonHS.selected=false;
					ButtonDrag.selected=true;
					inner.onDrag();
				});
			rawChildren.addChild(ButtonLeft);
			rawChildren.addChild(ButtonRight);
			rawChildren.addChild(ButtonUp);
			rawChildren.addChild(ButtonDown);
			rawChildren.addChild(ButtonCCW);
			rawChildren.addChild(ButtonCW);
			rawChildren.addChild(ButtonHS);
			rawChildren.addChild(ButtonVS);
//			rawChildren.addChild(ButtonFS);
//			rawChildren.addChild(ButtonRF);
			rawChildren.addChild(ButtonDrag);

//			titleTextField.backgroundColor=0xFFCCCC;
//			titleTextField.background=true;
		}

		public function setDrag():void {
			ButtonVS.selected=ButtonHS.selected=false;
			ButtonDrag.selected=true;
			inner.onDrag();
		} 

		private var _hasOverlay:Boolean;
		public function set hasOverlay(b:Boolean):void {
			_hasOverlay=b;
			invalidateDisplayList();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			ButtonLeft.y=ButtonRight.y=ButtonUp.y=ButtonDown.y=ButtonCCW.y=ButtonCW.y=(titleBar.height-ButtonLeft.height)/2;
			ButtonHS.y=ButtonVS.y=/*ButtonFS.y=*//*ButtonRF.y=*/ButtonDrag.y=ButtonLeft.y;
			ButtonLeft.x=160;
			ButtonRight.x=ButtonLeft.x+ButtonLeft.width;
			ButtonUp.x=ButtonRight.x+ButtonLeft.width+2;
			ButtonDown.x=ButtonUp.x+ButtonLeft.width;
			ButtonCCW.x=ButtonDown.x+ButtonLeft.width+2;
			ButtonCW.x=ButtonCCW.x+ButtonLeft.width;
			ButtonHS.x=ButtonCW.x+ButtonLeft.width+2;
			ButtonVS.x=ButtonHS.x+ButtonLeft.width+2;
//			ButtonFS.x=ButtonVS.x+ButtonLeft.width+2;
//			ButtonRF.x=ButtonFS.x+ButtonLeft.width+2;
			ButtonDrag.x=/*ButtonRF.x*//*ButtonFS.x*/ButtonVS.x+ButtonLeft.width+2;
			
			ButtonHS.visible=ButtonVS.visible=/*ButtonFS.visible=*//*ButtonRF.visible=*/ButtonDrag.visible=
				ButtonHS.enabled=ButtonVS.enabled=/*ButtonFS.enabled=*//*ButtonRF.enabled=*/ButtonDrag.enabled=_hasOverlay;

			ButtonLeft.visible=ButtonRight.visible=ButtonUp.visible=ButtonDown.visible=ButtonCCW.visible=ButtonCW.visible=
				ButtonLeft.enabled=ButtonRight.enabled=ButtonUp.enabled=ButtonDown.enabled=ButtonCCW.enabled=ButtonCW.enabled=!QuickNII.navilock;

			if(QuickNII.navilock)
				ButtonHS.visible=ButtonVS.visible=/*ButtonFS.visible=*//*ButtonRF.visible=*/ButtonDrag.visible=
					ButtonHS.enabled=ButtonVS.enabled=/*ButtonFS.enabled=*//*ButtonRF.enabled=*/ButtonDrag.enabled=false;
		}   
	}
}
