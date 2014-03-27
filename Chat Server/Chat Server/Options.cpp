//
//  Options.c
//
//  Created by Matt Zanchelli on 3/26/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include "Options.h"

#include "VectorHelper.h"

std::map<std::string, bool> getOptionsFromCommandLineArguments(int argc, const char *argv[])
{
	// Create a vector and pass it to the vector version of this function.
	std::vector<std::string> arguments = vectorOfStringsFromArrayOfCStrings(argc, argv);
	return getOptionsFromCommandLineArguments(&arguments);
}

std::map<std::string, bool> getOptionsFromCommandLineArguments(std::vector<std::string> *arguments)
{
	// Create an options mapping option strings to the enabled values.
	std::map<std::string, bool> options;
	
	// Find any specified options.
	for ( int i=0; i<arguments->size(); ++i ) {
		// The current argument being checked.
		std::string argument = (*arguments)[i];
		// Options start with '-' prefix.
		if ( argument.length() >= 2 && strncmp(argument.c_str(), "-", 1) == 0 ) {
			// Remove the argument from the vector.
			arguments->erase(arguments->begin()+i);
			// Must decrement the counter to not skip any items.
			i--;
			// The option string (starts after the '-').
			std::string option = argument.substr(1);
			// Turn the option on in the options map.
			options.insert(std::pair<std::string, bool>(option, true));
		}
	}
	
	// Return the options map.
	return options;
}
