//
//  main.m
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "CommandLineArguments.h"

#import "CSUserUniverse.h"

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
		[ports addObject:@(argumentInteger)];
	}
	
	// Return an immutable set of ports.
	return [NSSet setWithSet:ports];
}

int run(NSString *name, NSDictionary *options, NSArray *misc)
{
	@autoreleasepool {
		NSLog(@"Name: %@", name);
		NSLog(@"Options: %@", options);
		NSLog(@"Misc: %@", misc);
		
		// Get the port numbers.
		NSSet *ports = getPorts(misc);
		if ( !ports ) {
			return EXIT_FAILURE;
		}
		
		// Verbose mode will print out the chat messages from the server.
		verboseMode = [options[@"v"] isEqual:@YES];
		
#ifdef DEBUG
		{
			NSString *isVerboseModeEnabled = @"";
			if ( !verboseMode ) {
				isVerboseModeEnabled = @"not ";
			}
			NSLog(@"Verbose Mode is %@ enabled.", isVerboseModeEnabled);
		}
#endif
		
#ifdef DEBUG
		// Print "Starting Chat Server on port(s)...".
		if ( ports.count == 1 ) {
			// Just one port (singular).
			NSLog(@"Starting Chat Server on port %@.", [ports anyObject]);
		} else {
			// More than one port (plural).
			NSArray *portsArray = [ports allObjects];
			// The first port.
			NSString *portsString = [NSString stringWithFormat:@"%@", [portsArray firstObject]];
			for ( NSUInteger i=1; i<portsArray.count-1; ++i ) {
				// All middle ports.
				portsString = [portsString stringByAppendingFormat:@", %@", portsArray[i]];
			}
			// The last port.
			portsString = [portsString stringByAppendingFormat:@", and %@", [portsArray lastObject]];
			NSLog(@"Starting Chat Server on ports %@.", portsString);
		}
#endif
		
		
		// The universe!
		CSUserUniverse *universe = [[CSUserUniverse alloc] init];
		
		// Test adding a user to the universe.
		CSUser *newUser = [CSUser userWithName:@"Matt" andFileDescriptor:0];
		[universe addUser:newUser];
	}
	
    return EXIT_SUCCESS;
}

