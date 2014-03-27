//
//  CommandLineArguments.h
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

/// The function to be declared by your program.
int run(NSString *name, NSDictionary *options, NSArray *misc);

/// The true main function that handles the argument parsing.
int main(int argc, const char * argv[]);

/// Print the command-line usage of the program.
void printUsage();
