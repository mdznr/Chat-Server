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

/// Validate and parse command-line arguments in the form: chat_server <port> [<port> ... <port>]
/// @param argc The number of arguments (items in @c argv).
/// @param argv The argument vector.
/// @param options A map for all enabled options.
/// @param ports A vector of port numbers.
/// @return Whether or not this function was successful.
bool getArguments(int argc, const char * argv[], map<string, bool> *options, vector<unsigned int> *ports)
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
		string prefix("-"); // The prefix that appears before options.
		if ( !argument.compare(0, prefix.size(), prefix) ) {
			// The option string.
			string option = argument.substr(prefix.size(), argument.size()-prefix.size());
			// Remove the option from vector.
			arguments.erase(arguments.begin()+i);
			// Turn the option on in the options map.
			options->insert(pair<string, bool>(option, true));
		}
	}
	
	// Get the port numbers.
	for ( int i=0; i<arguments.size(); ++i ) {
		string port = arguments[i];
		unsigned int portNumber = stoi(port);
		ports->push_back(portNumber);
	}
	
	return true;
}

/// USAGE: chat_server <port> [<port> ... <port>]
int main(int argc, const char * argv[])
{
	// The options for running the program.
	// -v: Verbose Mode (Default: OFF).
	map<string, bool> options;
	
	// The port numbers to run the chat server on.
	vector<unsigned int> ports;
	
	// Validate and parse the arguments.
	if ( !getArguments(argc, argv, &options, &ports) ) {
		return EXIT_FAILURE;
	}
	
	// Verbose mode will print out the chat messages from the server.
	bool VERBOSE_MODE = false;
	if ( options["v"] ) {
		VERBOSE_MODE = true;
	}
	
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

