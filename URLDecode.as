package
{
	public function URLDecode(s:String):String
	{
		return unescape(s.replace(/\+/g," "));
	}
}