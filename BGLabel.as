package {
	import mx.controls.Label;
	import mx.core.IUITextField;

	public class BGLabel extends Label {
		public function BGLabel() {
			super()
		}

		public function getTextField():IUITextField {
			return textField
		}
	}
}
