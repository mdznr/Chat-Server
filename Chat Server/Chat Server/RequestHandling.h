//
//  RequestHandling.h
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#ifndef Chat_Server_RequestHandling_h
#define Chat_Server_RequestHandling_h

#include <netinet/in.h>

/// A structure to hold a file descriptor and a message.
typedef struct {
	/// Socket/File Descriptor.
	int sock;
	
	/// The address in the communications space of the socket.
	struct sockaddr_in address;
	
	/// Message sent by fd.
	char *msg;
} sock_msg;

/// Handle an HTTP request.
/// @param arg The request string.
/// @return @c NULL
/// @discussion Designed for use in new thread.
void *handleRequest(void *arg);

#endif
