//
//  ArrayHelper.c
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "ArrayHelper.h"

NSArray *arrayFromArrayOfCStrings(int count, const char *array[])
{
	NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:(NSUInteger)count];
	for ( NSUInteger i=0; i<count; ++i ) {
		NSString *string = [NSString stringWithFormat:@"%s", array[i]];
		[myArray addObject:string];
	}
	return myArray;
}
