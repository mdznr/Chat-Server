//
//  main.m
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "CommandLineArguments.h"

#import "CSUserUniverse.h"

#define BUFFER_SIZE 2048

// Your server must support at least 32 concurrent clients.
#define MAX_CLIENTS 32

int run(NSString *name, NSDictionary *options, NSArray *misc)
{
	@autoreleasepool {
		NSLog(@"Name: %@", name);
		NSLog(@"Options: %@", options);
		NSLog(@"Misc: %@", misc);
		
		// The universe!
		CSUserUniverse *universe = [[CSUserUniverse alloc] init];
		
		// Test adding a user to the universe.
		CSUser *newUser = [CSUser userWithName:@"Matt" andFileDescriptor:0];
		[universe addUser:newUser];
	}
	
    return EXIT_SUCCESS;
}

