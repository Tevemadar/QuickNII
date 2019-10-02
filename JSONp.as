package {
	public class JSONp {
		public static function parse(json:String):Object {
			return new JSONp(json).parse();
		}

		private var json:String;
		private var pos:int=0;
		public function JSONp(json:String) {
			this.json=json;
		}

		private function parse():Object {
			skipWhiteSpace();
			switch(json.charAt(pos)) {
				case "n":
					expect("null");
					return null;
				case "t":
					expect("true");
					return true;
				case "f":
					expect("false");
					return false;
				case "\"":
					return parseString();
				case "[":
					return parseArray();
				case "{":
					return parseObject();
				default:
					return parseNumber();
			}
			return null;
		}

		private function parseObject():Object {
			var o:Object={};
			pos++;
			skipWhiteSpace();
			if(json.charAt(pos)=="}") {
				pos++;
				return o;
			}
			var c:String;
			do {
				skipWhiteSpace();
				c=json.charAt(pos);
				if(c!="\"")throw new Error("Unquoted field name? "+c);
				var key:String=parseString();
				skipWhiteSpace();
				c=read();
				if(c!=":")throw new Error("Key-value separator expected after "+key+", got "+c);
				o[key]=parse();
				skipWhiteSpace();
				c=read();
				if(c!="}" && c!=",")throw new Error("Illegal field separator after "+key+": "+c);
			}
			while(c!="}");
			return o;
		}

		private function parseArray():Array {
			var a:Array=[];
			pos++;
			skipWhiteSpace();
			if(json.charAt(pos)=="]") {
				pos++;
				return a;
			}
			var c:String;
			do {
				a.push(parse());
				skipWhiteSpace();
				c=read();
				if(c!="]" && c!=",")throw new Error("Illegal array separator: "+c);
			}
			while(c!="]");
			return a;
		}

		private function parseNumber():Number {
			var org:int=pos;
			while(pos<json.length && "+-.eE1234567890".indexOf(json.charAt(pos))>=0)pos++;
			if(org==pos)throw new Error("Illegal token at "+pos);
			return parseFloat(json.substring(org,pos));
		}

		private function parseString():String {
			var s:String="";
			var c:String;
			pos++;
			while((c=read())!="\"") {
				if(c!="\\")s+=c;
				else {
					c=read();
					switch(c) {
						case "\"":
						case "\\":
						case "/":
							s+=c;break;
						case "b":s+="\b";break;
						case "f":s+="\f";break;
						case "n":s+="\n";break;
						case "r":s+="\r";break;
						case "t":s+="\t";break;
						case "u":s+=String.fromCharCode(parseInt(read()+read()+read()+read(),16));break;
						default: throw new Error("Illegal escape sequence: \\"+c);
					}
				}
			}
			return s;
		}

		private function expect(s:String):void {
			for(var i:int=0;i<s.length;i++)
				if(read()!=s.charAt(i))
					throw new Error("Unexpected literal "+json.substr(pos-i-1,i+1)+" (expected "+s+")");
		}

		private function read():String {
			if(pos>=json.length)throw new Error("Unexpected end of JSON");
			return json.charAt(pos++);
		}

		private function skipWhiteSpace():void {
			while(pos<json.length && " \t\r\n".indexOf(json.charAt(pos))>=0)pos++;
			if(pos>=json.length)throw new Error("Unexpected end of JSON");
		}

		public static function stringify(o:Object):String {
			var s:String="";
			var i:int;
			if(o==null)s="null";
			else if(o is Boolean || o is Number)s=o.toString();
			else if(o is String) {
				s+="\"";
				var t:String=o as String;
				for(i=0;i<t.length;i++) {
					var c:String=t.charAt(i);
					var pos:int="\"\\\b\f\n\r\t".indexOf(c);
					if(pos>=0)s+="\\"+("\"\\bfnrt").charAt(pos);
					else if(c>=" " && c<="~")s+=c;
					else s+="\\u"+(0x10000+t.charCodeAt(i)).toString(16).substr(1);
				}
				s+="\"";
			} else if(o is Array) {
				var a:Array=o as Array;
				s+="[";
				for(i=0;i<a.length;i++) {
					if(i>0)s+=",";
					s+=stringify(a[i]);
				}
				s+="]";
			} else {
				s+="{";
				var comma:Boolean=false;
				for(var p:String in o) {
					if(comma)s+=",";
					comma=true;
					s+=stringify(p);
					s+=":";
					s+=stringify(o[p]);
				}
				s+="}";
			}
			return s;
		}
	}
}
