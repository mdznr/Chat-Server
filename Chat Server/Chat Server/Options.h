//
//  Options.h
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Get the options (arguments prefixed with '-') from command line arguments.
/// @param argc The number of items in @c argv.
/// @param argv The argument vector.
/// @return A dicrionary of options to their value.
NSDictionary *getOptionsFromCommandLineArguments(int argc, const char *argv[]);

/// Get the options (arguments prefixed with '-') from command line arguments.
/// @param arguments The mutable array of arguments. Arguments formatted as options will be removed from the array.
/// @return A dictionary of options to their value.
NSDictionary *getOptionsFromCommandLineArgumentsFromArray(NSMutableArray *arguments);
