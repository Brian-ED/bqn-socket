# Example of calling this file would be:
# bqn netTest.bqn server 43 132 10 140

# 43 132 10 140 is just an example I made up.
# For testing, you should use your own local address,
# on linux you can see this with the command:
# hostname -i

# It should print the port to connect to,
# which you use in this command, where you replace 42597 with your port:
# bqn netTest.bqn client 43 132 10 140 42597


CreateClient‿CreateServer ← •Import "socket.bqn"

_blocking_ ← {•Delay∘𝔾⍟(@⊸≡)⊸⊢∘𝔽 •_While_ (@⊸≡)}
{
  "server"‿a‿dd‿re‿ss:
    address ← •ParseFloat¨ a‿dd‿re‿ss
    server←CreateServer@
      •Out "server is on port "∾•Repr server.port
      server.SearchForConnection _blocking_ 0.1 @
      connection ← server.AcceptConnection@
        port ← •ParseFloat connection.Listen@
        client ← address CreateClient port
          client.Send "hi from server"
          connection.SearchForMessage _blocking_ 0.1 @
          •Show connection.Listen@
        client.Close
      connection.Close@
    server.Close@
;
  "client"‿a‿dd‿re‿ss‿portStr:
    address ← •ParseFloat¨ a‿dd‿re‿ss
    port ← •ParseFloat portStr
    client ← address CreateClient port
      server ← CreateServer@
        •Out "server is on port "∾•Repr server.port
        client.Send •Repr server.port
        server.SearchForConnection _blocking_ 0.1 @
        connection ← server.AcceptConnection@
          •Show connection.Listen@
          client.Send "hi from client"
        connection.Close@
      server.Close@
    client.Close@
} •args
