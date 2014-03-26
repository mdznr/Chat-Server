//
//  Options.h
//  Chat Server
//
//  Created by Matt Zanchelli on 3/26/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#ifndef Chat_Server_Options_h
#define Chat_Server_Options_h

#include <map>

/// Get the options (arguments prefixed with '-') from command line arguments.
/// @param argc The number of items in @c argv.
/// @param argv The argument vector.
/// @return A map of arguments to their on/off value.
std::map<std::string, bool> getOptionsFromCommandLineArguments(int argc, const char *argv[]);

#endif
