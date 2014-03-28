//
//  ArrayHelper.h
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

/// Create an NSArray from an array of c strings.
/// @param count The number of items in @c array.
/// @param array The array of C strings.
/// @return A newly allocated array.
NSArray *arrayFromArrayOfCStrings(int count, const char *array[]);
