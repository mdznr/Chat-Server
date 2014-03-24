Using a programming language of your choice (C, C++, Java, Perl, Python), write a chat server that meets the requirements below. Note that this is not just a text-based chat server! And it must support both TCP and UDP connections from clients.

Your chat server must accept messages on multiple port numbers. The server must run from the command-line with the port numbers to listen on as the command-line arguments. At a minimum, there must be one port number specified. Here's the required command-line format:

	bash$ chat_server <port> [<port> ... <port>]

All communication between clients must be sent via your server. You may use any approach you like, though at a minimum, your server must support at least 32 concurrent clients (both TCP and UDP connections).

Authentication is not required. When a client connects, it logs in by sending the following message:

	ME IS <userid>
	
The userid must be unique and must not contain any space characters. Your chat server responds to a `ME IS` request with a line that contains either `OK` or `ERROR`. An error condition you must handle is if a duplicate user attempts to connect. Other errors may exist.

Messages your server must support are `SEND` and `BROADCAST`. The `SEND` message must be followed by a space character, then the target userid (see extra credit below). A `BROADCAST` message is sent to all users. Both end in a newline. Note that there is no required response from the server.

If a message is 99 bytes or less, a two-digit decimal number specifies the length of the message. UDP or TCP can be used for these short messages.

If a message is larger than 99 bytes, a chunking approach is used (similar to HTTP) to send the message (which could be text, an image file, any file, etc.). This approach requires the use of TCP. Unlike HTTP, you must use decimal (instead of hexadecimal) chunk sizes of up to 999 bytes. Chunk lengths will vary and are specified with a C prefix. Be sure to send a chunk of size 0 to indicate the end of the message. Here are two example chunks:

	C104
	abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
		
	C0
	
When a message is sent to a recipient, the `FROM` header specifies who the message is from (see examples below).

After every three messages sent to a client, your server must send a random message from one of the previous three senders (selected randomly). Further, make up at least ten random messages (including the ones listed below):

	Hey, you're kinda hot
	No way!
	I like Justin Bieber....a lot
	
Your server must not crash. Further, be sure to handle as many error conditions as you can detect. For example, if a client disconnects before all chunks are received/sent or before the message is received/sent, handle this quitely and gracefully in the server. Other errors to handle include messages sent to users that are not online or non-existent; in such cases, either drop the message or fill in with randomly generated message(s).

Your server must not output anything, unless a `-v` option (verbose) is specified on the command-line. In verbose mode, display all messages sent to and from the server. Use the following format (note that `\n` characters are shown where required in transmitted packets/datagrams):

	RCVD from 128.213.56.11: ME IS ladygaga\n
	SENT to 128.213.56.11: OK\n
	RCVD from 128.213.56.13: ME IS selenagomez\n
	SENT to 128.213.56.13: OK\n
	RCVD from 66.195.8.137: ME IS ladygaga\n
	SENT to 66.195.8.137: ERROR\n
	RCVD from ladygaga (128.213.56.11):
	  SEND selenagomez\n
	  9\n
	  You suck!
	SENT to selenagomez (128.213.56.13):
	  FROM ladygaga\n
	  9\n
	  You suck!
	RCVD from ladygaga (128.213.56.11):
	  SEND selenagomez\n
	  C108\n
	  step off my turf!\n
	  step off my turf!\n
	  step off my turf!\n
	  step off my turf!\n
	  step off my turf!\n
	  step off my turf!\n
	  C8\n
	  got it?!
	  C0
	SENT to selenagomez (128.213.56.13):
	  FROM ladygaga\n
	  C108\n
	  step off my turf!\n
	  step off my turf!\n
	  step off my turf!\n
	  step off my turf!\n
	  step off my turf!\n
	  step off my turf!\n
	  C8\n
	  got it?!
	  C0
	
	etc.
	
	SENT (randomly!) TO selenagomez (128.213.56.13):
	  FROM ladygaga\n
	  7
	  No way!
	RCVD from selenagomez (128.213.56.13):
	  BROADCAST\n
	  15\n
	  Leave me alone!
	SENT to selenagomez (128.213.56.13):
	  FROM selenagomez\n
	  15\n
	  Leave me alone!
	SENT to ladygaga (128.213.56.11):
	  FROM selenagomez\n
	  15\n
	  Leave me alone!
	
	etc.

**Extra Credit**: Extend the `SEND` request such that multiple userids can be included (space-delimited). For example:

	SEND selenagomez parishilton ladygaga
	etc.
  