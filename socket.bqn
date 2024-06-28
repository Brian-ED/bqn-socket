#! /usr/bin/env bqn

# TODO the byte order might be reversed sometimes,
# and i haven't tested with a machine that has reverse byte order,
# so errors might come about because of that.

HexToDec←{16⊸×⊸+˜´⌽(∾"0A"+⟜↕¨10‿6)⊐𝕩}

# Types of sockets
socket_type ⇐ {
  sock_stream    ⇐ 1   # Sequenced, reliable, connection-based byte streams
  sock_dgram     ⇐ 2   # Connectionless, unreliable datagrams of fixed maximum length.
  sock_raw       ⇐ 3   # Raw protocol interface.
  sock_rdm       ⇐ 4   # Reliably-delivered messages.
  sock_seqpacket ⇐ 5   # Sequenced, reliable, connection-based, datagrams of fixed maximum length.
  sock_dccp      ⇐ 6   # Datagram Congestion Control Protocol.
  sock_packet    ⇐ 10  # Linux specific way of getting packets at the dev level. For writing rarp and other similar things on the user level.

  # Flags to be ORed into the type parameter of socket and socketpair and used for the flags parameter of paccept.
  sock_cloexec  ⇐ 2000000  # Atomically set close-on-exec flag for the new descriptor(s).
  sock_nonblock ⇐ 4000  # Atomically mark descriptor(s) as non-blocking.
}
pf_inet ⇐ 2 # IP protocol family.
af_inet ⇐ pf_inet

errno ← {
  eperm           ⇐ 1 # Operation not permitted
  enoent          ⇐ 2 # No such file or directory
  esrch           ⇐ 3 # No such process
  eintr           ⇐ 4 # Interrupted system call
  eio             ⇐ 5 # Input/output error
  enxio           ⇐ 6 # No such device or address
  e2big           ⇐ 7 # Argument list too long
  enoexec         ⇐ 8 # Exec format error
  ebadf           ⇐ 9 # Bad file descriptor
  echild          ⇐ 10 # No child processes
  eagain          ⇐ 11 # Resource temporarily unavailable
  ewouldblock     ⇐ eagain # Same as EAgain in the c-gnu standard, seems the two are different sometimes, need to figure out when.
  enomem          ⇐ 12 # Cannot allocate memory
  eacces          ⇐ 13 # Permission denied
  efault          ⇐ 14 # Bad address
  enotblk         ⇐ 15 # Block device required
  ebusy           ⇐ 16 # Device or resource busy
  eexist          ⇐ 17 # File exists
  exdev           ⇐ 18 # Invalid cross-device link
  enodev          ⇐ 19 # No such device
  enotdir         ⇐ 20 # Not a directory
  eisdir          ⇐ 21 # Is a directory
  einval          ⇐ 22 # Invalid argument
  enfile          ⇐ 23 # Too many open files in system
  emfile          ⇐ 24 # Too many open files
  enotty          ⇐ 25 # Inappropriate ioctl for device
  etxtbsy         ⇐ 26 # Text file busy
  efbig           ⇐ 27 # File too large
  enospc          ⇐ 28 # No space left on device
  espipe          ⇐ 29 # Illegal seek
  erofs           ⇐ 30 # Read-only file system
  emlink          ⇐ 31 # Too many links
  epipe           ⇐ 32 # Broken pipe
  edom            ⇐ 33 # Numerical argument out of domain
  erange          ⇐ 34 # Numerical result out of range
  edeadlk         ⇐ 35 # Resource deadlock avoided
  enametoolong    ⇐ 36 # File name too long
  enolck          ⇐ 37 # No locks available
  enosys          ⇐ 38 # Function not implemented
  enotempty       ⇐ 39 # Directory not empty
  eloop           ⇐ 40 # Too many levels of symbolic links
  enomsg          ⇐ 42 # No message of desired type
  eidrm           ⇐ 43 # Identifier removed
  echrng          ⇐ 44 # Channel number out of range
  el2nsync        ⇐ 45 # Level 2 not synchronized
  el3hlt          ⇐ 46 # Level 3 halted
  el3rst          ⇐ 47 # Level 3 reset
  elnrng          ⇐ 48 # Link number out of range
  eunatch         ⇐ 49 # Protocol driver not attached
  enocsi          ⇐ 50 # No CSI structure available
  el2hlt          ⇐ 51 # Level 2 halted
  ebade           ⇐ 52 # Invalid exchange
  ebadr           ⇐ 53 # Invalid request descriptor
  exfull          ⇐ 54 # Exchange full
  enoano          ⇐ 55 # No anode
  ebadrqc         ⇐ 56 # Invalid request code
  ebadslt         ⇐ 57 # Invalid slot
  ebfont          ⇐ 59 # Bad font file format
  enostr          ⇐ 60 # Device not a stream
  enodata         ⇐ 61 # No data available
  etime           ⇐ 62 # Timer expired
  enosr           ⇐ 63 # Out of streams resources
  enonet          ⇐ 64 # Machine is not on the network
  enopkg          ⇐ 65 # Package not installed
  eremote         ⇐ 66 # Object is remote
  enolink         ⇐ 67 # Link has been severed
  eadv            ⇐ 68 # Advertise error
  esrmnt          ⇐ 69 # Srmount error
  ecomm           ⇐ 70 # Communication error on send
  eproto          ⇐ 71 # Protocol error
  emultihop       ⇐ 72 # Multihop attempted
  edotdot         ⇐ 73 # RFS specific error
  ebadmsg         ⇐ 74 # Bad message
  eoverflow       ⇐ 75 # Value too large for defined data type
  enotuniq        ⇐ 76 # Name not unique on network
  ebadfd          ⇐ 77 # File descriptor in bad state
  eremchg         ⇐ 78 # Remote address changed
  elibacc         ⇐ 79 # Can not access a needed shared library
  elibbad         ⇐ 80 # Accessing a corrupted shared library
  elibscn         ⇐ 81 # .lib section in a.out corrupted
  elibmax         ⇐ 82 # Attempting to link in too many shared libraries
  elibexec        ⇐ 83 # Cannot exec a shared library directly
  eilseq          ⇐ 84 # Invalid or incomplete multibyte or wide character
  erestart        ⇐ 85 # Interrupted system call should be restarted
  estrpipe        ⇐ 86 # Streams pipe error
  eusers          ⇐ 87 # Too many users
  enotsock        ⇐ 88 # Socket operation on non-socket
  edestaddrreq    ⇐ 89 # Destination address required
  emsgsize        ⇐ 90 # Message too long
  eprototype      ⇐ 91 # Protocol wrong type for socket
  enoprotoopt     ⇐ 92 # Protocol not available
  eprotonosupport ⇐ 93 # Protocol not supported
  esocktnosupport ⇐ 94 # Socket type not supported
  eopnotsupp      ⇐ 95 # Operation not supported
  epfnosupport    ⇐ 96 # Protocol family not supported
  eafnosupport    ⇐ 97 # Address family not supported by protocol
  eaddrinuse      ⇐ 98 # Address already in use
  eaddrnotavail   ⇐ 99 # Cannot assign requested address
  enetdown        ⇐ 100 # Network is down
  enetunreach     ⇐ 101 # Network is unreachable
  enetreset       ⇐ 102 # Network dropped connection on reset
  econnaborted    ⇐ 103 # Software caused connection abort
  econnreset      ⇐ 104 # Connection reset by peer
  enobufs         ⇐ 105 # No buffer space available
  eisconn         ⇐ 106 # Transport endpoint is already connected
  enotconn        ⇐ 107 # Transport endpoint is not connected
  eshutdown       ⇐ 108 # Cannot send after transport endpoint shutdown
  etoomanyrefs    ⇐ 109 # Too many references: cannot splice
  etimedout       ⇐ 110 # Connection timed out
  econnrefused    ⇐ 111 # Connection refused
  ehostdown       ⇐ 112 # Host is down
  ehostunreach    ⇐ 113 # No route to host
  ealready        ⇐ 114 # Operation already in progress
  einprogress     ⇐ 115 # Operation now in progress
  estale          ⇐ 116 # Stale file handle
  euclean         ⇐ 117 # Structure needs cleaning
  enotnam         ⇐ 118 # Not a XENIX named type file
  enavail         ⇐ 119 # No XENIX semaphores available
  eisnam          ⇐ 120 # Is a named type file
  eremoteio       ⇐ 121 # Remote I/O error
  edquot          ⇐ 122 # Disk quota exceeded
  enomedium       ⇐ 123 # No medium found
  emediumtype     ⇐ 124 # Wrong medium type
  ecanceled       ⇐ 125 # Operation canceled
  enokey          ⇐ 126 # Required key not available
  ekeyexpired     ⇐ 127 # Key has expired
  ekeyrevoked     ⇐ 128 # Key has been revoked
  ekeyrejected    ⇐ 129 # Key was rejected by service
  eownerdead      ⇐ 130 # Owner died
  enotrecoverable ⇐ 131 # State not recoverable
  erfkill         ⇐ 132 # Operation not possible due to RF-kill
  ehwpoison       ⇐ 133 # Memory page has hardware error
}

flags ← {
  msg_Oob          ⇐ HexToDec "1"
  msg_Peek         ⇐ HexToDec "2"
  msg_Dontroute    ⇐ HexToDec "4"
  msg_Ctrunc       ⇐ HexToDec "8"
  msg_Proxy        ⇐ HexToDec "10"
  msg_Trunc        ⇐ HexToDec "20"
  msg_Dontwait     ⇐ HexToDec "40"
  msg_Eor          ⇐ HexToDec "80"
  msg_Waitall      ⇐ HexToDec "100"
  msg_Fin          ⇐ HexToDec "200"
  msg_Syn          ⇐ HexToDec "400"
  msg_Confirm      ⇐ HexToDec "800"
  msg_Rst          ⇐ HexToDec "1000"
  msg_Errqueue     ⇐ HexToDec "2000"
  msg_Nosignal     ⇐ HexToDec "4000"
  msg_More         ⇐ HexToDec "8000"
  msg_Waitforone   ⇐ HexToDec "10000"
  msg_Batch        ⇐ HexToDec "40000"
  msg_Zerocopy     ⇐ HexToDec "4000000"
  msg_Fastopen     ⇐ HexToDec "20000000"
  msg_Cmsg_cloexec ⇐ HexToDec "40000000"
}

sockaddress ⇐ "{u16,[14]u8}"
# unsigned short int # sa_family
# char [14]; # sa_data


sockaddress_in ⇐ "{u16,u16,{u32},[8]u8}"

address_len ⇐ 16
addressType ⇐ {
  sin_family  ⇐ 0 # u16
  sin_port    ⇐ 1 # u16
  sin_address ⇐ 2 # {u32}
  sin_zero    ⇐ 3 # u8[8]
}

sockaddress_storage ⇐ "{u16,[118]u8,u64}"
#  {
#    ss_family    # u16
#    __ss_padding # u8[(128 - (sizeof (unsigned short int)) - sizeof (unsigned long int))]
#    __ss_align   # u64
#  }


ni_maxhost‿ni_maxserv ⇐ 1025‿32

# sizeof(address) ← 16

socketPath ⇐ "/usr/lib/x86_64-linux-gnu/libsocket++.so.1"
lf ← 10+@

pollIn ← 1

pollfd ⇐ "{i32,i16,i16}"
# int   # fd         # file descriptor
# short # events     # requested events
# short # revents    # returned events

fcntl       ⇐ socketPath •FFI "i32"‿"fcntl"‿"i32"‿"i32"‿"i32"
pollC       ⇐ socketPath •FFI "i32"‿"poll"‿("&"∾pollfd)‿"i32"‿"i32" # fds nfds(len of fds) timeout
socket      ⇐ socketPath •FFI "i32"‿"socket"‿"i32"‿"i32"‿"i32"
htons       ⇐ socketPath •FFI "u16"‿"htons"‿">u16"
send        ⇐ socketPath •FFI "i64"‿"send"‿"i32"‿"*u8"‿"u64"‿"i32"
connect     ⇐ socketPath •FFI "i32"‿"connect"‿"i32"‿"*{u16,u16,{u32},[8]u8}"‿"u32"
close       ⇐ socketPath •FFI "i32"‿"close"‿">i32"
recvC       ⇐ socketPath •FFI "i64"‿"recv"‿"i32"‿"&u8"‿"u64"‿"i32"
accept      ⇐ socketPath •FFI "i32"‿"accept"‿"i32"‿('&'∾sockaddress)‿"&u32"
bind        ⇐ socketPath •FFI "i32"‿"bind"‿"i32"‿('&'∾sockaddress_in)‿"u32"
getsockname ⇐ socketPath •FFI "i32"‿"getsockname"‿"i32"‿('&'∾sockaddress_in)‿"&u32"
ntohs       ⇐ socketPath •FFI "u16"‿"ntohs"‿">u16"
listen      ⇐ socketPath •FFI "i32"‿"listen"‿"i32"‿"i32"

o_nonblock ← 2048
f_setfl ← 4

Recv ← {𝕊sockfd‿buffer‿bufferLength‿flags:
  len‿updatedBuffer ← RecvC⟨sockfd, buffer, bufferLength, flags⟩
  {
    ¯1≠×len?
    # sometimes returns ⟨@⟩ when using recv multiple times, not sure why
    @+len↑updatedBuffer
  ;
    # Handle error
    err ← {(𝕏⟨⟩).Read 0}@•FFI"*i32"‿"__errno_location"
    P←1↓⟜∾lf⊸∾¨
    ⟨
      "No messages are available at the socket"
      # "The socket is marked nonblocking and the receive operation"
      # "would block, or a receive timeout had been set and the"
      # "timeout expired before data was received.  POSIX.1 allows"
      # "either error to be returned for this case, and does not"
      # "require these constants to have the same value, so a"
      # "portable application should check for both possibilities."
    ⟩P⊸!(err≢errno.eagain) ∧ err≢errno.ewouldblock

    ⟨
      "The argument sockfd is an invalid file descriptor."
    ⟩P⊸!err≢errno.ebadf

    ⟨
      "A remote host refused to allow the network connection"
      "(typically because it is not running the requested"
      "service)."
    ⟩P⊸!err≢errno.econnrefused

    ⟨
      "The receive buffer pointer(s) point outside the process's"
      "address space."
    ⟩P⊸!err≢errno.efault

    ⟨
      "The receive was interrupted by delivery of a signal before"
      "any data was available; see signal(7)."
    ⟩P⊸!err≢errno.eintr

    ⟨
      "Invalid argument passed."
    ⟩P⊸!err≢errno.einval

    ⟨
      "Could not allocate memory for recvmsg()."
    ⟩P⊸!err≢errno.enomem

    ⟨
      "The socket is associated with a connection-oriented"
      "protocol and has not been connected (see connect(2) and"
      "accept(2))."
    ⟩P⊸!err≢errno.enotconn

    ⟨
      "The file descriptor sockfd does not refer to a socket."
    ⟩P⊸!err≢errno.enotsock

    !"Unknown error code "∾•Repr err
  }
}

# work in progress plans on proper polling
# something‿lenOfFds ← Poll lenOfFds‿
# TODO experiment and find what's the best return value of Poll, maybe revents (meaning return-events)
Poll ← {𝕊fd:
  len‿⟨fdNew‿events‿revents⟩ ← PollC ⟨⋈fd‿1‿0⋄pollIn⋄0⟩ #  int poll(struct pollfd *fds, nfds_t nfds, int timeout);
  #•Show len‿fdNew‿events‿revents
  { 0: @ # timeout
  ;¯1: !"Error"
  ; 1: len
  }×len
}
# something has the representation:
# int   # fd         # file descriptor
# short # events     # requested events
# short # revents    # returned events


CreateServer ⇐ {𝕊:
  # create socket
  fd ← Socket⟨pf_inet, socket_type.sock_stream, 0⟩

  # bind to open port
  address ← ⟨af_inet,0,⟨0⟩,8⥊0⟩

  address ↩ {
    1‿·: !"bind error:"
  ; 0‿⟨a⟩: a
  } Bind⟨fd, ⋈address, address_len⟩

  # read port
  address ↩ {
    ⟨err, ⟨addressNew⟩, ⟨lenNew⟩⟩ ← Getsockname⟨fd, ⋈address, ⋈address_len⟩
    !lenNew≡address_len
    "Couldn't get socket name"!¬err
    addressNew
  }

  port⇐⌊ Ntohs 1⊑address

  "listen error:"!¬Listen fd‿1
  Fcntl ⟨fd, f_setfl, o_nonblock⟩

  SocketClose ← Close

  SearchForConnection ⇐ Poll∘fd

  # accept incoming connection
  AcceptConnection ⇐ {𝕊@:
    caddress_len ← 16

    # Todo, poll before accepting. I think that would be more inline with the standard.
    cfd‿⟨⟨n⋄address⟩⟩‿⟨·⟩ ← Accept⟨fd, ⋈⟨0, 14⥊0⟩, ⋈caddress_len⟩

    # I have no idea what the two first elements are, and rest is the ipv4 address
    address(4↑↓˜)↩2

    "Connection not found"!¯1≢cfd
    "Only address IPV4 allowed"!2≡n
    connection ← cfd

    SearchForMessage ⇐ Poll∘connection

    _WithMessage_ ⇐ {@⊸≡◶⟨({𝕩.Close@}⊢𝔽)Listen∘@⋄𝔾⟩SearchForMessage}

    Listen ⇐ {𝕊lengthOfReadMessage:
      # read from client with recv!
      l ← 1024⍟(@⊸≡)𝕩
      Recv⟨connection, l⥊0, l, flags.msg_dontwait⟩
    }
    Close ⇐ SocketClose∘connection
    address⇐
  }
  _WithConnection_ ⇐ {@⊸≡◶⟨({𝕩.Close@}⊢𝔽)AcceptConnection∘@⋄𝔾⟩SearchForConnection}

  Close ⇐ SocketClose∘fd
}


CreateClient ⇐ {ipv4_address𝕊port:
  fd ← Socket⟨pf_inet, socket_type.sock_stream, 0⟩

  # connect to machine at specified port
  address ← ⟨
    af_inet
    Htons port # Htons sets byte order to follow network protocal standards
    ⋈ 256⊸×⊸+˜´ipv4_address
    8⥊0
  ⟩

  # connect to server
  "connect error:"!¬Connect⟨fd, ⋈address, address_len⟩

  SendRenamed ← Send
  Send ⇐ {SendRenamed⟨fd, 𝕩-@, ≠𝕩, 0 ⟩}
  Close ⇐ Close∘fd
}

_asServer ⇐ {({𝕩.Close}⊢𝔽)CreateServer}
_asClient ⇐ {({𝕩.Close}⊢𝔽)CreateClient}

#       AF_INET6
#              src points to a character string containing an IPv6
#              network address.  The address is converted to a struct
#              in6_addr and copied to dst, which must be sizeof(struct
#              in6_addr) (16) bytes (128 bits) long.  The allowed formats
#              for IPv6 addresses follow these rules:
#
#              •  The preferred format is x:x:x:x:x:x:x:x.  This form
#                 consists of eight hexadecimal numbers, each of which
#                 expresses a 16-bit value (i.e., each x can be up to 4
#                 hex digits).
#
#              •  A series of contiguous zero values in the preferred
#                 format can be abbreviated to ::.  Only one instance of
#                 :: can occur in an address.  For example, the loopback
#                 address 0:0:0:0:0:0:0:1 can be abbreviated as ::1.  The
#                 wildcard address, consisting of all zeros, can be
#                 written as ::.
#
#              •  An alternate format is useful for expressing
#                 IPv4-mapped IPv6 addresses.  This form is written as
#                 x:x:x:x:x:x:d.d.d.d, where the six leading xs are
#                 hexadecimal values that define the six most-significant
#                 16-bit pieces of the address (i.e., 96 bits), and the
#                 ds express a value in dotted-decimal notation that
#                 defines the least significant 32 bits of the address.
#                 An example of such an address is
#                 ::FFFF:204.152.189.116.
#
#              See RFC 2373 for further details on the representation of
#              IPv6 addresses.
#
#