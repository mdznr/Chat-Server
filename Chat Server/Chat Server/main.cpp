//
//  main.cpp
//  Chat Server
//
//  Created by Matt Zanchelli on 3/24/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include "CommandLineArguments.h"

// Your server must support at least 32 concurrent clients.
#define MAX_CONCURRENT_CLIENTS 32

using namespace std;

/// Get the arguments
/// @param arguments The arguments.
/// @param ports A vector of port numbers.
/// @return Whether or not this function was successful.
bool pullPortsFromArguments(vector<string> *arguments, vector<unsigned int> *ports)
{
	// Check if there's at least one *real* argument (port no.).
	if ( arguments->size() < 1 ) {
		cerr << "Must specify at least one port number.\n";
		return false;
	}
	
	// Get the port numbers.
	for ( int i=0; i<arguments->size(); ++i ) {
		string port = (*arguments)[i];
		unsigned int portNumber = stoi(port);
		ports->push_back(portNumber);
	}
	
	return true;
}

bool verbose_mode = false;

int run(string name, map<string, bool> options, vector<string> misc)
{
	// The port numbers to run the chat server on.
	vector<unsigned int> ports;
	
	// Validate and parse the arguments.
	if ( !pullPortsFromArguments(&misc, &ports) ) {
		return EXIT_FAILURE;
	}
	
	// Verbose mode will print out the chat messages from the server.
	verbose_mode = options["v"];
	
#ifdef DEBUG
	cout << "Verbose Mode is ";
	if ( !verbose_mode ) {
		cout << "not ";
	}
	cout << "enabled." << endl;
#endif
	
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
