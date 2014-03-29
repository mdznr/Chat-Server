//
//  RequestHandling.cpp
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include "RequestHandling.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <pthread.h>

#include <arpa/inet.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>

#define BUFFER_SIZE 2048

#warning Log user out when connection is closed.

void *handleRequest(void *argument)
{
	// Unpack argument into variables.
	sock_addr *arg = (sock_addr *) argument;
	int fd = arg->sock;
	struct sockaddr_in client = arg->address;
	
	// Read the IP Address into a string.
	char *ip_addr = inet_ntoa((struct in_addr)client.sin_addr);
	
	// Keep receiving while the connection is still open.
	while ( true ) {
		// Create a buffer to read the message into.
		char buffer[BUFFER_SIZE];
		// Receive the message.
		ssize_t n = recv(fd, buffer, BUFFER_SIZE - 1, 0);
		// Check recv() return value.
		if ( n <= 0 ) {
			// Errored.
			perror("recv()");
			break;
		} else {
			// Stream received message.
			buffer[n] = '\0';
#ifdef DEBUG
			NSLog(@"Received message from fd %d at %s`: %s", fd, ip_addr, buffer);
#endif
		}
		
		// Send a message back.
		// Buffer to load received messages into.
		char sendbuffer[BUFFER_SIZE];
		
		// Copy the request string back into buffer for testing.
		strcpy(sendbuffer, buffer);
		
		ssize_t send_client_n = send(fd, sendbuffer, strlen(sendbuffer), 0);
		if ( send_client_n < strlen(sendbuffer) ) {
			perror("send()");
			goto end;
		}
	}
	
end:
	
	// The socket is no longer needed.
	close(fd);
	
	// Use this to return message back to calling thread and terminate.
	pthread_exit(NULL);
	
	return NULL;
}
