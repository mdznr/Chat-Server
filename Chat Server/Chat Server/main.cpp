//
//  main.cpp
//  Chat Server
//
//  Created by Matt Zanchelli on 3/24/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include "CommandLineArguments.h"

#include <stdio.h>
#include <stdlib.h>

#include <limits.h>
#include <string.h>
#include <unistd.h>

#include <arpa/inet.h>
#include <netinet/in.h>

#include <pthread.h>

#include <sys/errno.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/types.h>


#define BUFFER_SIZE 2048

// Your server must support at least 32 concurrent clients.
#define MAX_CLIENTS 32

using namespace std;

/// Get the arguments
/// @param arguments The arguments.
/// @param ports A vector of port numbers.
/// @return Whether or not this function was successful.
bool pullPortsFromArguments(vector<string> *arguments, vector<unsigned int> *ports)
{
	// Check if there's at least one *real* argument (port no.).
	if ( arguments->size() < 1 ) {
		cerr << "Must specify at least one port number.\n";
		return false;
	}
	
	// Get the port numbers.
	for ( int i=0; i<arguments->size(); ++i ) {
		string port = (*arguments)[i];
		unsigned int portNumber = stoi(port);
		ports->push_back(portNumber);
	}
	
	return true;
}

bool verbose_mode = false;

int run(string name, map<string, bool> options, vector<string> misc)
{
	// The port numbers to run the chat server on.
	vector<unsigned int> ports;
	
	// Validate and parse the arguments.
	if ( !pullPortsFromArguments(&misc, &ports) ) {
		return EXIT_FAILURE;
	}
	
	// Verbose mode will print out the chat messages from the server.
	verbose_mode = options["v"];
	
#ifdef DEBUG
	cout << "Verbose Mode is ";
	if ( !verbose_mode ) {
		cout << "not ";
	}
	cout << "enabled." << endl;
#endif
	
#ifdef DEBUG
	// Print "Starting Chat Server on port(s)...".
	if ( ports.size() == 1 ) {
		// Just one port (singular).
		cout << "Starting Chat Server on port " << ports[0] << "." << endl;
	} else {
		// More than one port (plural).
		cout << "Starting Chat Server on ports " << ports[0];     // First port.
		for ( int i=1; i<ports.size()-1; ++i ) {
			cout << ", " << ports[i];                             // All middle ports.
		}
		cout << ", and " << ports[ports.size()-1] << "." << endl; // Last port.
	}
#endif
	
	// Create the listener socket as TCP socket. (use SOCK_DGRAM for UDP)
	int sock = socket(PF_INET, SOCK_STREAM, 0);
	if ( sock < 0 ) {
		perror("socket()");
		exit(1);
	}
	
#warning Handle multiple ports.
	unsigned short port = ports[0];
	
	// Create the server.
	struct sockaddr_in server;
	server.sin_family = PF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(port);
	
	// Bind.
	bind(sock, (struct sockaddr *) &server, sizeof(server));
	
	// Create the client.
	struct sockaddr_in client;
	socklen_t fromlen = sizeof(client);
	listen(sock, MAX_CLIENTS); // 5 is the number of backlogged waiting clients.
	printf("Listener socket created and bound to port %d\n", port);
	
	// Keep taking requests from client.
	while (true) {
		// Accept client connection.
		int fd = accept(sock, (struct sockaddr *) &client, &fromlen);
		
#ifdef DEBUG
		printf("Accepted client connection on fd: %d\n", fd);
#endif
		
		// Create a buffer to read the message into.
		char buffer[BUFFER_SIZE];
		
		// Receive the message.
		ssize_t n = recv(fd, buffer, BUFFER_SIZE - 1, 0);
		// Check recv() return value.
		if ( n <= 0 ) {
			// Errored.
			perror("recv()");
			continue;
		} else {
			// Stream received message.
			buffer[n] = '\0';
#ifdef DEBUG
			//printf("Received message from fd %d: %s\n", fd, buffer);
#endif
		}
		
		// Handle message.
	}
	
	// We'll never get here.
    return EXIT_SUCCESS;
}
