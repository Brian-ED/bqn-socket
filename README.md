This is a socket library for making it easier to use sockets in BQN.
It is currently unstable with little testing done

currently only linux, more operating systems planned.

# Tested on
linux x86-64 Mint-OS.

# extra info
Some macros and defines were manually resolved by including a lot. Mistakes in conversions are likely. To find back some of the macros that were copied you may look in `<sys/socket.h>`, `<netdb.h>`(only for macros NI_MAXHOST and NI_MAXSERV), `<unistd.h>` (only for the close function), and `<arpa/inet.h>`. I have no idea if the macros are machine-dependant.

Could be worth resolving all these macros automatically with [c-header-to-bqn-ffi](https://github.com/Brian-ED/c-header-to-bqn-ffi/).