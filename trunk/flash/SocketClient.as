package{

	import flash.net.Socket;
	import flash.events.*;	
  import flash.text.TextField;
	import Loggable;
	
	public class SocketClient implements Loggable{ //extends Loggable{

 		include "Loggable_impl.as";

		public static const KILL_SIGNAL:String = 'KEEP ALIVE?';

		private var socket:Socket;
		private var host:String;
		private var port:Number;
		private var listeners:Object;
		
		private function callEventListeners(eventName, returnValue):void{
			if(listeners && listeners[eventName]){
				for(var i=0;i<listeners[eventName].length;i++){
					listeners[eventName][i].call(returnValue);
				}				
			}			
		}
		
		private function handleGenericEvent(event):void{
			trace(event.toString());
			callEventListeners(event.type, event);
		}

		private function handleSocketData(event:ProgressEvent):void{			
			var response = socket.readUTFBytes( socket.bytesAvailable );
			if(response != SocketClient.KILL_SIGNAL){
				logger(response);
				callEventListeners(event.type, response);			
			}			
		}

		private function handleSocketConnect(event:Event):void{
			callEventListeners(event.type, event);
		}

		private function handleSocketClose(event:Event):void{
			callEventListeners(event.type, event);
		}
		
		private function addDefaultEventListeners():void{
			socket.addEventListener(Event.CONNECT, handleSocketConnect);
			addEventListener(Event.CONNECT, function(e){logger('Connection Open')});
			
			socket.addEventListener(Event.CLOSE, handleSocketClose);
			addEventListener(Event.CLOSE, function(e){logger('Connection Closed')});

			socket.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);

			socket.addEventListener(IOErrorEvent.IO_ERROR, handleGenericEvent);			

			socket.addEventListener(DataEvent.DATA, handleGenericEvent);						
			addEventListener(DataEvent.DATA, function(e){logger(e.toString())});			
		}

		public function connect():void{			
			addDefaultEventListeners();
			try{
				logger('Connecting to '+host+':'+port);
				socket.connect(host, port);
			}catch(e:Error){
				logger("Error: "+e.toString());
			}						
		}
		
		public function SocketClient(){//(output:TextField){
			host = '127.0.0.1';
			port = 5001;
			socket = new Socket();
			listeners = {};
		}
		
		public function sendMessage( message:String ){

			message = "message;" + message + "\n";

			if ( socket && socket.connected ){
				//logger("Sending message: "+message)
				socket.writeUTFBytes( message );
			}else{
				logger("Socket not connected");
			}		      
		}
		
		public function get connected():Boolean{
			return socket.connected;
		}
		
		public function addEventListener(eventName, eventFunction):void{
			if(!listeners[eventName])
				listeners[eventName] = []
			listeners[eventName].push(eventFunction);	
		}
		
	}
	
}

// TODO: Tell the server to close the socket when you're done w/ it
