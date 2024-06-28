# Example of calling this file would be:
# bqn netTest.bqn server 43 132 10 140

# 43 132 10 140 is just an example I made up.
# For testing, you should use your own local address,
# on linux you can see this with the command:
# hostname -i

# It should print the port to connect to,
# which you use in this command, where you replace 42597 with your port:
# bqn netTest.bqn client 43 132 10 140 42597


# This example is similar to netTest.bqn,
# except it uses a few modifiers to attempt to simplify.

_asClient‿_asServer ← •Import "socket.bqn"

{"server"‿a‿dd‿re‿ss:
  address ← •ParseFloat¨ a‿dd‿re‿ss
  {𝕊server:
    •Out "server is on port "∾•Repr server.port
    {𝕊connection:
      port ← •ParseFloat connection.Listen@
      {𝕊client:
        client.Send •Show "hi from server"
        •Show connection._withMessage_ (•Delay∘0.1⊸⊢) •_While_ (@⊸≡)@
      }_asClient´ address‿port
    } server._WithConnection_ (•Delay∘0.1⊸⊢) •_While_ (@⊸≡)@
  } _asServer@
;"client"‿a‿dd‿re‿ss‿portStr:
  address ← •ParseFloat¨ a‿dd‿re‿ss
  port ← •ParseFloat portStr
  {𝕊client:
    {𝕊server:
      •Out "server is on port "∾•Repr server.port
      client.Send •Repr server.port
      {𝕊connection:
        •Show connection.Listen@
        client.Send •Show "hi from client"
      } server._WithConnection_ (•Delay∘0.1⊸⊢) •_While_ (@⊸≡)@
    }_asServer@
  } _asClient´address⋈port
} •args
