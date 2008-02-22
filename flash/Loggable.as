package { 
	import flash.text.TextField;
	
	interface Loggable{
			
	    function set outputField( field:TextField ):void;

			function logger( msg:String ):void;

	}
}