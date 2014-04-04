//
//  NSString+whitespace.h
//  Chat Server
//
//  Created by Matt Zanchelli on 4/3/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (whitespace)

/// Returns a new string made from the receiver by replacing all trailing whitespace (including newlines).
///	@return A new string with the trailig whitespace removed.
- (NSString *)stringByRemovingTrailingWhitespace;

@end
