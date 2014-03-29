//
//  RequestHandling.h
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include <netinet/in.h>

#include "CSUser.h"

/// A structure to hold a file descriptor and a message.
typedef struct {
	/// Socket/File Descriptor.
	int sock;
	
	/// The address in the communications space of the socket.
	struct sockaddr_in address;
	
	///	A reference to the user.
	void *user;
} sock_addr;

/// Handle a request.
/// @param arg The socket address structure.
/// @return @c NULL
/// @discussion Designed for use in new thread.
void *handleRequest(void *arg);
