//
//  Options.c
//  Chat Server
//
//  Created by Matt Zanchelli on 3/26/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include <stdio.h>

#include <string>
#include <cstring>

#include "Options.h"

std::map<std::string, bool> getOptionsFromCommandLineArguments(int argc, const char *argv[])
{
	// Create an options mapping option strings to on/off values.
	std::map<std::string, bool> options;
	
	// Find any specified options.
	for ( int i=0; i<argc; ++i ) {
		// The current argument being checked.
		const char *argument = argv[i];
		// Options start with '-' prefix.
		if ( strlen(argument) >= 2 && strncmp(argument, "-", 1) ) {
			// The option string (starts after the '-').
			std::string option = &argument[1];
			// Turn the option on in the options map.
			options.insert(std::pair<std::string, bool>(option, true));
		}
	}
	
	// Return the options map.
	return options;
}
