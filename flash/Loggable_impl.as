public var _outputField:TextField;

public function set outputField( field:TextField ):void{
	_outputField = field;
}

public function logger( msg:String ):void{
	if(_outputField != null) _outputField.text = msg+"\n"+_outputField.text;
}
