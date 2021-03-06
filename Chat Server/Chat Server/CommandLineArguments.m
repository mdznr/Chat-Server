//
//  CommandLineArguments.m
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "CommandLineArguments.h"

#import "ArrayHelper.h"
#import "Options.h"

int main(int argc, const char * argv[])
{
#if !__has_feature(objc_arc)
	// Autorelease Pool.
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif
	
	// The objects to pass along to run().
	NSString *name;
	NSDictionary *options = [[NSDictionary alloc] init];
	NSArray *arguments = [[NSArray alloc] init];
	
	// The executable's name is the first argument.
	name = [NSString stringWithFormat:@"%s", argv[0]];
	
	if ( argc >= 2 ) {
		// Get the remaining arguments in an array.
		NSMutableArray *allArguments = [NSMutableArray arrayWithArray:arrayFromArrayOfCStrings(argc-1, &argv[1])];
		// Remove the arguments that are options, and hold on to the options.
		options = getOptionsFromCommandLineArgumentsFromArray(allArguments);
		// Immutable copy to return.
		arguments = allArguments;
	}
	
	// Run the program with the specified options.
	return run(name, options, arguments);
	
#if !__has_feature(objc_arc)
	[pool drain];
#endif
}

void printUsage()
{
	printf("Usage: chat_server <port> [<port> ... <port>]\n");
}

