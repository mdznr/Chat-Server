//
//  CommandLineArguments.c
//
//  Created by Matt Zanchelli on 3/26/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include "CommandLineArguments.h"

#include "Options.h"
#include "VectorHelper.h"

int main(int argc, const char * argv[])
{
	std::string name;
	std::vector<std::string> arguments;
	std::map<std::string, bool> options;
	
	// The executable's name is the first argument.
	name = argv[0];
	
	if ( argc >= 2 ) {
		// Get the remaining arguments in a vector.
		arguments = vectorOfStringsFromArrayOfCStrings(argc-1, &argv[1]);
		// Remove the arguments that are options, and hold on to the options.
		options = getOptionsFromCommandLineArguments(&arguments);
	}
	
	// Run the program with the specified options.
	return run(name, options, arguments);
}

void printUsage()
{
	std::cout << "Usage: chat_server <port> [<port> ... <port>]" << std::endl;
}

