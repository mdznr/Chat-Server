//
//  CommandLineArguments.h
//
//  Created by Matt Zanchelli on 3/26/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#ifndef Chat_Server_CommandLineArguments_h
#define Chat_Server_CommandLineArguments_h

#include <iostream>
#include <cstring>
#include <vector>
#include <map>
#include <string>

/// The function to be declared by your program.
int run(std::string name, std::map<std::string, bool> options, std::vector<std::string> arguments);

/// The true main function that handles the argument parsing.
int main(int argc, const char * argv[]);

/// Print the command-line usage of the program.
void printUsage();

#endif
