//
//  main.c
//  Chat Client
//
//  Created by Matt Zanchelli on 3/29/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <pthread.h>
#include <string.h>
#include <strings.h> /* for bcopy */
#include <unistd.h>
#include <arpa/inet.h>

#define BUFFER_SIZE 1024

/// Handle incoming network traffic for use in new thread.
/// @param argument an int* cast as void*
/// @return @C NULL
void *handleNetwork(void *argument);

int main(int argc, const char *argv[])
{
	if ( argc != 3 ) {
		perror("Usage: ./chatclient <hostname> <port>");
		exit(1);
	}
	
	const char *hostname = argv[1];
	unsigned short port = (unsigned short) atoi(argv[2]);
	if ( !port ) {
		perror("Invalid port specified.");
		exit(1);
	}
	
	// Socket.
	int sock = socket(PF_INET, SOCK_STREAM, 0);
	if ( sock < 0 ) {
		perror("socket()");
		exit(1);
	}
	
	// Server.
	struct sockaddr_in server;
	server.sin_family = PF_INET;
	
	struct hostent *hp = gethostbyname(hostname);
	if ( hp == NULL ) {
		perror("Unknown host");
		exit(1);
	}
	
	bcopy((char *)hp->h_addr, (char *)&server.sin_addr, hp->h_length);
	server.sin_port = htons(port);
	
	// Connect.
	if ( connect(sock, (struct sockaddr *)&server, sizeof(server) ) < 0 ) {
		perror("connect()");
		exit(1);
	}
	
	printf("Successfully connected to the chat server at %s:%hu.\n", hostname, port);
	
	// Incoming network thread.
	pthread_t tid;
	// Create a new thread for the user.
	int *fd = (int *) malloc(sizeof(int));
	*fd = sock;
	if ( pthread_create(&tid, NULL, handleNetwork, (void *) fd) != 0 ) {
		perror("Could not create thread.");
		close(sock);
		exit(1);
	}
	
	// Keep getting user input.
	while (1) {
		// Print line header. Ex: "127.0.0.1:8127 >"
		printf("%s:%hu > ", hostname, port);
		
		// Get input.
		char *msg = calloc(BUFFER_SIZE, sizeof(char));
		fgets(msg, BUFFER_SIZE, stdin);
		// Remove trailing newline, if there is one.
		unsigned long msglen = strlen(msg);
		if ( msglen > 0 && msg[msglen-1] == '\n' ) {
			msg[msglen-1] = '\0';
		}
		
		// Send.
		ssize_t send_n = send(sock, msg, strlen(msg), 0);
		if ( send_n < strlen(msg) ) {
			perror("send()");
			exit(1);
		}
		
		free(msg);
	}
	
	// The connection can now be closed.
	close(sock);
	
	return EXIT_SUCCESS;
}

void *handleNetwork(void *argument)
{
	// Unload the arguments.
	int *fd = (int *) argument;
	
	// Buffer to load received messages into.
	char buffer[BUFFER_SIZE];
	
	// Receive.
	while (1) {
		// BLOCK
		ssize_t received_n = recv(*fd, buffer, BUFFER_SIZE - 1, 0);
		if ( received_n == 0 ) {
			// Peer has closed its half side of the (TCP) connection.
			fflush(NULL);
			break;
		} else if ( received_n < 0 ) {
			// Error.
			fflush(NULL);
			perror("recv()");
			break;
		} else {
			// End the buffer with a null-terminator.
			buffer[received_n] = '\0';
			// Print out the received message.
			printf("%s\n", buffer);
		}
	}
	
	// Use this to return message back to calling thread and terminate.
	pthread_exit(NULL);
	
	return NULL;
}
