//
//  Options.c
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "Options.h"
#import "ArrayHelper.h"

NSDictionary *getOptionsFromCommandLineArguments(int argc, const char *argv[])
{
	// Create an array and pass it to the array version of this function.
	NSMutableArray *arguments = [NSMutableArray arrayWithArray:arrayFromArrayOfCStrings(argc, argv)];
	return getOptionsFromCommandLineArgumentsFromArray(arguments);
}

NSDictionary *getOptionsFromCommandLineArgumentsFromArray(NSMutableArray *arguments)
{
	// Create an options mapping option strings to the enabled values.
	NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:arguments.count];
	
	// Find any specified options.
	for ( NSUInteger i=0; i<arguments.count; ++i ) {
		// The current argument being checked.
		NSString *argument = arguments[i];
		// Options start with '-' prefix.
		if ( argument.length >= 2 && [argument hasPrefix:@"-"] ) {
			// Remove the argument from the vector.
			// Must decrement the counter to not skip any items.
			[arguments removeObjectAtIndex:i--];
			// The option string (starts after the '-').
			NSString *option = [argument substringFromIndex:1];
			// Turn the option on in the options map.
			options[option] = @(YES);
		}
	}
	
	// Return the options map.
	return options;
}

