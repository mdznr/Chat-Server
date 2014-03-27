//
//  VectorHelper.h
//
//  Created by Matt Zanchelli on 3/26/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#ifndef Chat_Server_VectorHelper_h
#define Chat_Server_VectorHelper_h

#include <stdio.h>
#include <cstring>
#include <map>
#include <string>
#include <vector>

/// Create a vector of strings from an array of c strings.
/// @param count The number of items in @c array.
/// @param array The array of c strings.
/// @return A vector of strings.
std::vector<std::string> vectorOfStringsFromArrayOfCStrings(int count, const char *array[]);

#endif
