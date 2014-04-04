//
//  NSString+whitespace.m
//  Chat Server
//
//  Created by Matt Zanchelli on 4/3/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "NSString+whitespace.h"

@implementation NSString (whitespace)

- (NSString *)stringByRemovingTrailingWhitespace
{
	// Implementation via http://stackoverflow.com/a/4546230/1544685
	NSRange range = [self rangeOfString:@"\\s*$" options:NSRegularExpressionSearch];
	return [self stringByReplacingCharactersInRange:range withString:@""];
}

@end
