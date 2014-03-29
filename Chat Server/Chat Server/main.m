//
//  main.m
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "CommandLineArguments.h"
#import "ProgramOptions.h"

#include <arpa/inet.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sys/errno.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/types.h>

#include "RequestHandling.h"

#import "CSUserUniverse.h"

#warning How to handle the log statements? Debug? Verbose?

///	The size for a buffer.
#define BUFFER_SIZE 2048

/// THe maximum number of clients.
/// The server must support at least 32 concurrent clients.
#define MAX_CLIENTS 32

///	Get the ports from the misc. arguments.
///	@param arguments The misc. arguments given to the program.
///	@return A set of port numbers.
NSSet *getPorts(NSArray *arguments)
{
	if ( arguments.count < 1 ) {
		perror("Must specify at least one port number.\n");
		return nil;
	}
	
	// A set to collect port numbers in.
	NSMutableSet *ports = [[NSMutableSet alloc] initWithCapacity:arguments.count];
	
	// Get the port numbers.
	for ( NSString *argument in arguments ) {
		// Get the integer value of the argument string.
		NSInteger argumentInteger = [argument integerValue];
		if ( argumentInteger == 0 ) {
			// No valid integerValue for argument string, therefore is *not* a valid port.
			continue;
		}
		// Add port to the array of ports.
		[ports addObject:[NSNumber numberWithInteger:argumentInteger]];
	}
	
	// Return an immutable set of ports.
	return [NSSet setWithSet:ports];
}

///	Send a response back to the client.
///	@param response The response string to send back.
///	@param client The file descriptor of the client.
void sendResponseToClient(NSString *response, int client)
{
	// The c string version of response string.
	const char *cresponse = [response UTF8String];
	
	// Send a message back.
	ssize_t send_client_n = send(client, cresponse, strlen(cresponse), 0);
	if ( send_client_n < strlen(cresponse) ) {
		perror("send()");
	}
}

int run(NSString *name, NSDictionary *options, NSArray *misc)
{
#ifdef DEBUG
	NSLog(@"Name: %@", name);
	NSLog(@"Options: %@", options);
	NSLog(@"Misc: %@", misc);
#endif
	
	// Get the port numbers.
	NSSet *ports = getPorts(misc);
	if ( !ports ) {
		return EXIT_FAILURE;
	}
	
	// Verbose mode will print out the chat messages from the server.
	verboseMode = [[options objectForKey:@"v"] isEqual:[NSNumber numberWithBool:YES]];
	
#ifdef DEBUG
	// Print "Verbose Mode is ___ enabled.".
	{
		NSString *isVerboseModeEnabled = @"";
		if ( !verboseMode ) {
			isVerboseModeEnabled = @"not ";
		}
		NSLog(@"Verbose Mode is %@enabled.", isVerboseModeEnabled);
	}
#endif
	
#ifdef DEBUG
	// Print "Starting Chat Server on port(s)...".
	{
		if ( ports.count == 1 ) {
			// Just one port (singular).
			NSLog(@"Starting Chat Server on port %@.", [ports anyObject]);
		} else {
			// More than one port (plural).
			NSArray *portsArray = [ports allObjects];
			// The first port.
			NSString *portsString = [NSString stringWithFormat:@"%@", [portsArray objectAtIndex:0]];
			for ( NSUInteger i=1; i<portsArray.count-1; ++i ) {
				// All middle ports.
				portsString = [portsString stringByAppendingFormat:@", %@", portsArray[i]];
			}
			// The last port.
			portsString = [portsString stringByAppendingFormat:@", and %@", [portsArray lastObject]];
			NSLog(@"Starting Chat Server on ports %@.", portsString);
		}
	}
#endif
	
	// Create the listener socket as TCP socket. (use SOCK_DGRAM for UDP)
#warning Enable UDP, too. (SOCK_DGRAM)
	int sock = socket(PF_INET, SOCK_STREAM, 0);
	if ( sock < 0 ) {
		perror("socket()");
		exit(1);
	}
	
#warning Handle multiple ports.
	unsigned short port = [((NSNumber *)[ports anyObject]) unsignedShortValue];
	
	// Create the server.
	struct sockaddr_in server;
	server.sin_family = PF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(port);
	
	// Bind.
	socklen_t len = sizeof(server);
	if ( bind(sock, (const struct sockaddr *) &server, len) < 0 ) {
		perror("bind()");
		exit(1);
	}
	
	// Create the client.
	struct sockaddr_in client;
	socklen_t fromlen = sizeof(client);
	listen(sock, MAX_CLIENTS); // 5 is the number of backlogged waiting clients.
	NSLog(@"Listener socket created and bound to port %d.", port);
	
	// Threads
	pthread_t tid[MAX_CLIENTS];
	
	// The universe!
	CSUserUniverse *universe = [[CSUserUniverse alloc] init];
	
	// Keep taking requests from client.
	while (true) {
		// Accept client connection.
		int fd = accept(sock, (struct sockaddr *) &client, &fromlen);
#ifdef DEBUG
		NSLog(@"Accepted client connection on fd: %d", fd);
#endif
		// The first message must be authenticating a user.
		char buffer[BUFFER_SIZE]; // A buffer to read the message into.
		// Receive the message.
		ssize_t n = recv(fd, buffer, BUFFER_SIZE-1, 0);
		// Check if recv() errored.
		if ( n <= 0 ) {
			// Errored.
			perror("recv()");
			close(fd);
			continue;
		}
		
		// Ensure the command string terminates.
		buffer[n] = '\0';
		NSString *command = [NSString stringWithUTF8String:buffer];
#ifdef DEBUG
		NSLog(@"Received command: %@", command);
#endif
		
		// Make sure command is the authentication command.
		if ( ![command hasPrefix:@"ME IS "] ) {
			// Did not properly authenticate.
#ifdef DEBUG
			NSLog(@"New connection did not properly authenticate.");
#endif
			sendResponseToClient(@"ERROR", fd);
			close(fd);
			continue;
		}
		
		// Get the components of the command.
		NSArray *components = [command componentsSeparatedByString:@" "];
		if ( components.count != 3 ) {
#ifdef DEBUG
			NSLog(@"Spaces are not allowed in username.");
#endif
			sendResponseToClient(@"ERROR", fd);
			close(fd);
			continue;
		}
		
		// The username is the third component of the command.
		NSString *username = (NSString *) [components objectAtIndex:2];
		
		// Create and add the user to the universe.
		CSUser *user = [CSUser userWithUsername:username andFileDescriptor:fd];
		if ( ![universe addUser:user] ) {
#ifdef DEBUG
			NSLog(@"A user with name '%@' is already logged in.", username);
#endif
			sendResponseToClient(@"ERROR", fd);
			close(fd);
			continue;
		}
		
#ifdef DEBUG
		NSLog(@"User: %@ logged in.", user);
#endif
		sendResponseToClient(@"OK", fd);
		
#warning pass User object into new thread?
		// Create a new thread for the user.
		sock_addr *arg = (sock_addr *) malloc(sizeof(sock_addr));
		arg->sock = fd;
		arg->address = server;
		if ( pthread_create(&tid[fd], NULL, handleRequest, (void *) arg) != 0 ) {
			perror("Could not create thread.");
			close(fd);
			continue;
		}
	}
	return EXIT_SUCCESS;
}

