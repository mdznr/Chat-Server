//
//  Options.h
//
//  Created by Matt Zanchelli on 3/26/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#ifndef Chat_Server_Options_h
#define Chat_Server_Options_h

#include <stdio.h>
#include <cstring>
#include <map>
#include <string>
#include <vector>

/// Get the options (arguments prefixed with '-') from command line arguments.
/// @param argc The number of items in @c argv.
/// @param argv The argument vector.
/// @return A map of options to their enabled value.
std::map<std::string, bool> getOptionsFromCommandLineArguments(int argc, const char *argv[]);

/// Get the options (arguments prefixed with '-' from command line arguments.
/// @param arguments The argument vector. Arguments formatted as options will be removed from this vector.
/// @return A map of options to their enabled value.
std::map<std::string, bool> getOptionsFromCommandLineArguments(std::vector<std::string> *arguments);

#endif
