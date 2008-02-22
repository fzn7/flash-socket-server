// CREATE THE SOCKET & CONNECT
var socket = new SocketClient();

socket.outputField = output;
socket.connect();

socket.addEventListener(Event.CONNECT, function(r){
	socket.sendMessage("Ping!");											 
});

// SETUP THE STAGE
function captureMouseLocation(e){
	socket.sendMessage('['+e.stageX+','+e.stageY+']');
}

stage.addEventListener(MouseEvent.MOUSE_DOWN, function(downEvent:MouseEvent){
	stage.addEventListener(MouseEvent.MOUSE_MOVE, captureMouseLocation);	
});
stage.addEventListener(MouseEvent.MOUSE_UP, function(downEvent:MouseEvent){
	stage.removeEventListener(MouseEvent.MOUSE_MOVE, captureMouseLocation);
});