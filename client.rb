require 'em-websocket-client'
require 'em-websocket'

serverPort  = ARGV[0]
connectPort = ARGV[1]

class Server
    def initialize(serverPort, client)
        @serverPort = serverPort
        @client = client
    end
    def run()
      EM.run {
          puts "server port: " + @serverPort
          EM::WebSocket.run(:host => "0.0.0.0", :port => @serverPort) do |ws|
            ws.onopen { |handshake|
              puts "WebSocket connection open"

              # Access properties on the EM::WebSocket::Handshake object, e.g.
              # path, query_string, origin, headers
              # Publish message to the client
              host = "#{handshake.headers['Host']}"
              host =~ /:(\d*)/
              port = $1

              ws.send "Hello Client, you connected to #{handshake.path}"
            }

            ws.onclose { puts "Connection closed" }

            ws.onmessage { |msg|
              puts "Recieved message: #{msg}"
              case msg
              when "dig" then
                  ws.send "you got 100 bitcoin"
              else
                  ws.send "Pong: #{msg}"
              end
            }
          end
       }
    end
end

class Client
    def initialize()
        @isConnect  = false
    end
    def setConnect(isConnect)
        @isConnect = isConnect
    end
    def isConnect()
        return @isConnect
    end
    def run(connectPort)
        puts "connect to #{connectPort}"
          EM.run do
            conn = EventMachine::WebSocketClient.connect("ws://0.0.0.0:" + connectPort)
            conn.errback do |e|
              puts "Got error: #{e}"
            end

            conn.stream do |msg|
              puts "<#{msg}>"
              if msg.data == "done"
                conn.close_connection
              end
            end

            conn.disconnect do
              setConnect(false)
              puts "gone"
            end

            loop do
                puts "input your message"
                conn.send_msg STDIN.gets.chomp
            end
          end
    end
end

client = Client.new()

t1 = Thread.fork {
    puts "server starting..."
    server = Server.new(serverPort, client)
    server.run()
}

t2 = Thread.fork{
    puts "client starting..."
    client.run(connectPort)
}

t1.join
t2.join


# prints out:
# <Hello!>
# <done>
# gone
