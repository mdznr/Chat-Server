//
//  main.cpp
//  Chat Server
//
//  Created by Matt Zanchelli on 3/24/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include <iostream>
#include <vector>

using namespace std;

/// Pull the ports into a vector from the command-line arguments.
/// @param argc The number of arguments (items in @c argv).
/// @param argv The argument vector.
/// @return A vector of port numbers.
vector<int> getPorts(int argc, const char * argv[])
{
	// USAGE: chat_server <port> [<port> ... <port>]
	
	// Holding vector for all the ports.
	vector<int> ports;
	
	// Collect all port numbers in relevant arguments.
	for ( unsigned int i=1; i<argc; ++i ) {
		const char *port = argv[i];
		unsigned int portNumber = atoi(port);
		ports.push_back(portNumber);
	}
	
	// Return the ports.
	return ports;
}

int main(int argc, const char * argv[])
{
	// Check if there's at least one *real* argument (port no.).
	if ( argc < 2 ) {
		cerr << "Must specify at least one port number.\nUsage: chat_server <port> [<port> ... <port>]";
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
		for ( unsigned int i=1; i<ports.size()-1; ++i ) {
			cout << ", " << ports[i];                             // All middle ports.
		}
		cout << ", and " << ports[ports.size()-1] << "." << endl; // Last port.
	}
#endif
	
    return EXIT_SUCCESS;
}

