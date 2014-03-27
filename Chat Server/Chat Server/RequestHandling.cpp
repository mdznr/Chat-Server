//
//  RequestHandling.cpp
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include "RequestHandling.h"

#include <iostream>
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

using namespace std;

void *handleRequest(void *argument)
{
	// Unpack argument into variables.
	sock_msg *arg = (sock_msg *) argument;
	int fd = arg->sock;
	struct sockaddr_in client = arg->address;
	char *requestString = arg->msg;
	
	cout << requestString << endl;
	
	// Send a message back.
	
	// Buffer to load received messages into.
	char buffer[BUFFER_SIZE];
	
	// Copy the request string back into buffer for testing.
	strcpy(buffer, requestString);
	
	ssize_t send_client_n = send(fd, buffer, strlen(buffer), 0);
	if ( send_client_n < strlen(buffer) ) {
		perror("send()");
		goto end;
	}
	
end:
	
	// The socket is no longer needed.
	close(fd);
	
	// Use this to return message back to calling thread and terminate.
	pthread_exit(NULL);
	
	return NULL;
}
