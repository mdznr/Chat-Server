//
//  main.cpp
//  Chat Server
//
//  Created by Matt Zanchelli on 3/24/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include <iostream>
#include <vector>
#include <map>

// Your server must support at least 32 concurrent clients.
#define MAX_CONCURRENT_CLIENTS 32

using namespace std;

/// Pull the ports into a vector from command-line arguments.
/// @param argc The number of arguments (items in @c argv).
/// @param argv The argument vector.
/// @return A vector of port numbers.
vector<int> getPorts(int argc, const char * argv[])
{
	// USAGE: chat_server <port> [<port> ... <port>]
	
	// Holding vector for all the ports.
	vector<int> ports;
	
	// Collect all port numbers in relevant arguments.
	for ( int i=1; i<argc; ++i ) {
		const char *port = argv[i];
		unsigned int portNumber = atoi(port);
		ports.push_back(portNumber);
	}
	
	// Return the ports.
	return ports;
}

/// Validate and parse command-line arguments.
/// @param argc The number of arguments (items in @c argv).
/// @param argv The argument vector.
/// @return Whether or not this function was successful.
bool getArguments(int argc, const char * argv[], map<string, bool> *options)
{
	// Check if there's at least one *real* argument (port no.).
	if ( argc < 2 ) {
		cerr << "Must specify at least one port number.\nUsage: chat_server <port> [<port> ... <port>]";
		return false;
	}
	
	// Get the argument in a C++ vector.
	vector<string> arguments;
	for ( int i=1; i<argc; ++i ) {
		string argument = string(argv[i]);
		arguments.push_back(argument);
	}
	
	// Find any specified options.
	for ( int i=0; i<arguments.size(); ++i ) {
		string argument = arguments[i]; // Current argument being checked.
		string prefix("-"); // Prefix that appears before options.
		if ( !argument.compare(0, prefix.size(), prefix) ) {
			string option = argument.substr(prefix.size(), argument.size()-prefix.size());
			// TODO: Remove option from vector.
			options->insert(pair<string, bool>(option, true));
		}
	}
	
	return true;
}

int main(int argc, const char * argv[])
{
	// The options for running the program.
	// -v: Verbose Mode (Default: OFF).
	map<string, bool> options;
	
	bool VERBOSE_MODE = false;
	if ( options["v"] ) {
		VERBOSE_MODE = true;
	}
	
	// Validate and parse the arguments.
	if ( !getArguments(argc, argv, &options) ) {
		return EXIT_FAILURE;
	}
	
	// Get all the ports to have the chat server run on.
	vector<int> ports = getPorts(argc, argv);
	
#ifdef DEBUG
	// Print "Starting Chat Server on port(s)...".
	if ( ports.size() == 1 ) {
		// Just one port (singular).
		cout << "Starting Chat Server on port " << ports[0] << "." << endl;
	} else {
		// More than one port (plural).
		cout << "Starting Chat Server on ports " << ports[0];     // First port.
		for ( int i=1; i<ports.size()-1; ++i ) {
			cout << ", " << ports[i];                             // All middle ports.
		}
		cout << ", and " << ports[ports.size()-1] << "." << endl; // Last port.
	}
#endif
	
    return EXIT_SUCCESS;
}

