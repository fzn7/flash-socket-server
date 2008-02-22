class TCPSocket
  KILL_SIGNAL = 'KEEP ALIVE?'
    
  def keep_alive?    
    begin      
      return self.write(TCPSocket::KILL_SIGNAL) && self.flush    
    rescue Errno::EPIPE
      return false
    end
  end  
end

def send_policy_file(sock)
  policy = <<-POL
<?xml version="1.0" encoding="UTF-8"?>
<cross-domain-policy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.adobe.com/xml/schemas/PolicyFileSocket.xsd">
    <allow-access-from domain="*" to-ports="*" secure="false" />
    <site-control permitted-cross-domain-policies="master-only" />
</cross-domain-policy>
  POL
  puts sock.write(policy)
  sock.flush
  sock.close
end

$data_handler = Proc.new do |client,data|
  client.write("Data received")
  client.flush
end

def handle_client_data(client, data)
  puts "received: #{data}"
  if data =~ /policy-file-request/
    puts "sending policy file"
    send_policy_file(client)
  else
    $data_handler.call(client, data)
  end  
end

def register_data_handler(data_handler)
  $data_handler = data_handler
end

def add_client_listener(client)
  Thread.new do
    loop do
      if client.closed?
        break
      else
        data = client.recvfrom( 5000 )[0].chomp
        handle_client_data(client, data)
      end
    end    
  end
end