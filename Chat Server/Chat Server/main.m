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

#import "CSUserUniverse.h"

///	The size for a buffer.
#define BUFFER_SIZE 2048

/// THe maximum number of clients.
/// The server must support at least 32 concurrent clients.
#define MAX_CLIENTS 32

CSUserUniverse *universe;

/// A structure to hold a file descriptor and a message.
typedef struct {
	/// Socket/File Descriptor.
	int sock;
	
	/// The address in the communications space of the socket.
	struct sockaddr_in address;
	
	///	The user's name
	const char *username;
} sock_addr;

///	Handle TCP requests on a port.
///	@param port The port connected to.
///	@return @c NULL
void *handleTCP(void *port);

///	Handle UDP requests on a port.
///	@param port The port connected to.
///	@return @c NULL
void *handleUDP(void *port);

///	Handle a request
///	@param server The server.
///	@param client The client.
///	@param fd The file descriptor accepted on.
/// @param tid The threads to give to give out to the clients.
void handleRequest(struct sockaddr_in *server, struct sockaddr_in *client, int fd, pthread_t *tid);

/// Handle a client.
/// @param arg The socket address structure.
/// @return @c NULL
/// @discussion Designed for use in new thread.
void *handleClient(void *arg);

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
	// Log message.
	if ( verboseMode ) {
		NSLog(@"SENT to %d: %@", client, response);
	}
	
	// The c string version of response string.
	const char *cresponse = [response UTF8String];
	
	// Send a message back.
	ssize_t send_client_n = send(client, cresponse, strlen(cresponse), 0);
	if ( send_client_n < strlen(cresponse) ) {
		perror("send()");
	}
}

///	Send a response back to a user.
///	@param response The response string to send back.
///	@param user The user to send a response.
void sendResponseToUser(NSString *response, CSUser *user)
{
	// Log message.
	if ( verboseMode ) {
		NSLog(@"SENT to %@ (%d): %@", [user.username capitalizedString], user.fd, response);
	}
	
	// The c string version of response string.
	const char *cresponse = [response UTF8String];
	
	// The file descriptor for the user.
	int client = user.fd;
	
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
	
	unsigned long numThreads = 2 * [ports count];
	
	// Threads.
	// Have TCP and UDP threads for each port.
	pthread_t tid[numThreads];
	
	// Create the universe!
	universe = [[CSUserUniverse alloc] init];
	
	// Create TCP and UDP threads for each port.
	NSArray *allPorts = [ports allObjects];
	for ( NSUInteger i=0; i<[allPorts count]; ++i ) {
		// Get the port number.
		NSNumber *portNo = [allPorts objectAtIndex:i];
		unsigned short *port = (unsigned short *) malloc(sizeof(unsigned short));
		*port = [portNo unsignedShortValue];
		
		// Create TCP thread.
		if ( pthread_create(&tid[(2*i)], NULL, handleTCP, (void *) port) != 0 ) {
			perror("Could not create TCP thread.");
		}
		
		// Create UDP thread.
		if ( pthread_create(&tid[(2*i)+1], NULL, handleUDP, (void *) port) != 0 ) {
			perror("Could not create UDP thread.");
		}
	}
	
	// Wait for threads to join back.
	for ( unsigned long i=0; i<numThreads; ++i ) {
		pthread_join(tid[i], NULL);
	}
	
	return EXIT_SUCCESS;
}

void *handleTCP(void *argument)
{
	unsigned short *port = (unsigned short *) argument;
	
	// Threads.
	// Have threads for each possible client.
	pthread_t tid[MAX_CLIENTS];
	
	// Create the listener socket as TCP socket. (use SOCK_DGRAM for UDP)
	int sock = socket(PF_INET, SOCK_STREAM, 0);
	if ( sock < 0 ) {
		perror("socket()");
		exit(1);
	}
	
	// Create the server.
	struct sockaddr_in server;
	server.sin_family = PF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(*port);
	
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
#ifdef DEBUG
	NSLog(@"TCP listener socket created and bound to port %d.", *port);
#endif
	
	// Keep taking requests from client.
	while (true) {
		// Accept client connection.
		int fd = accept(sock, (struct sockaddr *) &client, &fromlen);
		if ( fd == -1 ) {
			NSLog(@"Failed to accept client connection.");
			continue;
		}
		handleRequest(&server, &client, fd, tid);
	}
	
	return NULL;
}

void *handleUDP(void *argument)
{
	unsigned short *port = (unsigned short *) argument;
	
	// Threads.
	// Have threads for each possible client.
	pthread_t tid[MAX_CLIENTS];
	
	// Create the listener socket as TCP socket. (use SOCK_DGRAM for UDP)
	int sock = socket(PF_INET, SOCK_DGRAM, 0);
	if ( sock < 0 ) {
		perror("socket()");
		exit(1);
	}
	
	// Create the server.
	struct sockaddr_in server;
	server.sin_family = PF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(*port);
	
	// Bind.
	socklen_t len = sizeof(server);
	if ( bind(sock, (const struct sockaddr *) &server, len) < 0 ) {
		perror("bind()");
		exit(1);
	}
	
	// Create the client.
	struct sockaddr_in client;
	socklen_t fromlen = sizeof(client);
	listen(sock, MAX_CLIENTS);
#ifdef DEBUG
	NSLog(@"UDP listener socket created and bound to port %d.", *port);
#endif
	
	// Keep taking requests from client.
	while (true) {
		// Accept client connection.
		int fd = accept(sock, (struct sockaddr *) &client, &fromlen);
		if ( fd == -1 ) {
//			NSLog(@"%d", errno);
//			NSLog(@"Failed to accept client connection.");
			continue;
		}
		handleRequest(&server, &client, fd, tid);
	}
	
	return NULL;
}

void handleRequest(struct sockaddr_in *server, struct sockaddr_in *client, int fd, pthread_t *tid)
{
	// Read the IP Address into a string.
	char *ip_addr = inet_ntoa((struct in_addr)client->sin_addr);
	
#ifdef DEBUG
	NSLog(@"Accepted client connection (%s) on fd %d.", ip_addr, fd);
#endif
	// A buffer to read the message into.
	char buffer[BUFFER_SIZE];
	// Receive the message.
	ssize_t n = recv(fd, buffer, BUFFER_SIZE-1, 0);
	// Check if recv() errored.
	if ( n <= 0 ) {
		// Errored.
		perror("recv()");
		close(fd);
		return;
	}
	
	// Ensure the command string terminates.
	buffer[n] = '\0';
	NSString *command = [[NSString stringWithUTF8String:buffer] stringByRemovingTrailingWhitespace];
	
	if ( verboseMode ) {
		NSLog(@"RCVD from %s: %@", ip_addr, command);
	}
	
	// Make sure command is the log in command.
	if ( ![command hasPrefix:@"ME IS "] ) {
		// Did not properly log in.
#warning How to include ip_addr? like @"SENT to %s: %@", ip_addr, command
		sendResponseToClient(@"ERROR: Must log in first.", fd);
		close(fd);
		return;
	}
	
	// Get the components of the command.
	NSArray *components = [command componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ( components.count != 3 ) {
		sendResponseToClient(@"ERROR: Spaces are not allowed in a username.", fd);
		close(fd);
		return;
	}
	
	// The username is the third component of the command.
	NSString *username = (NSString *) [components objectAtIndex:2];
	// 9. Usernames must be case insensitive; downcase all usernames.
	username = [username lowercaseString];
	
	// Create and add the user to the universe.
	CSUser *user = [CSUser userWithUsername:username andFileDescriptor:fd];
	if ( ![universe addUser:user] ) {
		sendResponseToClient(@"ERROR: A user with that username is already logged in.", fd);
		close(fd);
		return;
	}
	
#ifdef DEBUG
	NSLog(@"User: %@ logged in.", [user.username capitalizedString]);
#endif
	sendResponseToClient(@"OK", fd);
	
	// Create a new thread for the user.
	sock_addr *arg = (sock_addr *) malloc(sizeof(sock_addr));
	arg->sock = fd;
	arg->address = *server;
	arg->username = [[user username] UTF8String];
	if ( pthread_create(&tid[fd], NULL, handleClient, (void *) arg) != 0 ) {
		perror("Could not create thread.");
		close(fd);
		return;
	}
}

void *handleClient(void *argument)
{
	// Unpack argument into variables.
	sock_addr *arg = (sock_addr *) argument;
	int fd = arg->sock;
	struct sockaddr_in client = arg->address;
	NSString *username = [NSString stringWithUTF8String:arg->username];
	
	// Get a reference to the user with the specified username.
	CSUser *user = [universe findUserWithName:username];
	if ( !user ) {
		// Failed t find user.
		goto end;
	}

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
			// Errored or ended.
			break;
		} else {
			// Stream received message.
			buffer[n] = '\0';
			if ( verboseMode ) {
				NSLog(@"RCVD from %@ (%s): %s", [user.username capitalizedString], ip_addr, buffer);
			}
		}
		
		// Handle command.
		NSString *command = [[NSString stringWithUTF8String:buffer] stringByRemovingTrailingWhitespace];
		if ( [command hasPrefix:@"SEND "] ) {
			// SEND
			NSArray *components = [command componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			// Must have at least four components.
			if ( [components count] < 4 ) {
				sendResponseToClient(@"ERROR: Not enough arguments for 'SEND' command.", fd);
				continue;
			}
			NSString *fromUsername = [[components objectAtIndex:1] lowercaseString];
			NSString *toUsername = [[components objectAtIndex:2] lowercaseString];
			NSString *message = [command substringFromIndex:5+1+[fromUsername length]+1+[toUsername length]];
			if ( [user sendOutgoingMessage:message toUserWithName:toUsername] ) {
				sendResponseToUser(@"OK", user);
			} else {
				sendResponseToClient(@"ERROR: Could not send message to user.", fd);
			}
		} else if ( [command hasPrefix:@"BROADCAST "] ) {
			// BROADCAST
			NSArray *components = [command componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			// Must have at least three components.
			if ( [components count] < 3 ) {
				sendResponseToClient(@"ERROR: Not enough arguments for 'BROADCAST' command.", fd);
				continue;
			}
			NSString *fromUsername = [[components objectAtIndex:1] lowercaseString];
			NSString *message = [command substringFromIndex:9+1+[fromUsername length]+1];
			[user broadcastMessage:message];
			sendResponseToUser(@"OK", user);
		} else if ( [command hasPrefix:@"WHO HERE "] ) {
			NSArray *components = [command componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			// Must have three components ("WHO HERE" is two of them).
			if ( [components count] != 3 ) {
				sendResponseToClient(@"ERROR: Invalid number of arguments for 'WHO HERE' command.", fd);
				continue;
			}
			NSString *fromUsername = [[components objectAtIndex:2] lowercaseString];
#warning do any kind of check to make sure this user is OK?
			NSString *listOfUsers = [universe listOfUsers];
			sendResponseToClient(listOfUsers, fd);
		} else if ( [command hasPrefix:@"LOGOUT "] ) { // BROADCAST
			NSArray *components = [command componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			// Must have two components.
			if ( [components count] != 2 ) {
				sendResponseToClient(@"ERROR: Invalid number of arguments for 'LOGOUT' command.", fd);
				continue;
			}
			NSString *fromUsername = [[components objectAtIndex:1] lowercaseString];
			CSUser *foundUser = [universe findUserWithName:fromUsername];
			if ( !foundUser ) {
				// Could not find user.
				sendResponseToClient(@"ERROR: Could not find the user to logout.", fd);
				continue;
			}
#warning the way this protocol works is anyone can log another user out. WAT?
			if ( ![universe removeUser:foundUser] ) {
				// Could not remove user from universe.
				sendResponseToClient(@"ERROR: Could not logout user.", fd);
				continue;
			}
			sendResponseToClient(@"OK", fd);
			// End.
			break;
		} else {
			// Unrecognized command.
			sendResponseToClient(@"ERROR: Unrecognized command.", fd);
		}
	}
	
end:
	
	// The user has lost connection, remove them from the universe.
	[universe removeUser:user];
	
	// The socket is no longer needed.
	close(fd);
	
	// Use this to return message back to calling thread and terminate.
	pthread_exit(NULL);
	
	return NULL;
}

