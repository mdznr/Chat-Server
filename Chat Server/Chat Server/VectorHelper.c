//
//  VectorHelper.c
//
//  Created by Matt Zanchelli on 3/26/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#include "VectorHelper.h"

std::vector<std::string> vectorOfStringsFromArrayOfCStrings(int count, const char *array[])
{
	// Create empty vector for
	std::vector<std::string> myVector;
	
	// Push each string into the vector.
	for ( int i=0; i<count; ++i ) {
		myVector.push_back(std::string(array[i]));
	}
	
	// Return the vector.
	return myVector;
}
