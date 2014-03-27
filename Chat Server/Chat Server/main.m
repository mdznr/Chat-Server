//
//  main.m
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandLineArguments.h"

#define BUFFER_SIZE 2048

// Your server must support at least 32 concurrent clients.
#define MAX_CLIENTS 32

int run(NSString *name, NSDictionary *options, NSArray *misc)
{
	@autoreleasepool {
		NSLog(@"Name: %@", name);
		NSLog(@"Options: %@", options);
		NSLog(@"Misc: %@", misc);
	}
    return 0;
}

