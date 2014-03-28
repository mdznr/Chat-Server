//
//  CSUserUniverse.m
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "CSUserUniverse.h"

@interface CSUserUniverse ()

#pragma mark - Private Properties

/// All the users that exist in this universe.
@property (strong, nonatomic) NSMutableArray *users;

@end


#pragma mark -

@implementation CSUserUniverse

- (id)init
{
	self = [super init];
	if ( self ) {
		_users = [[NSMutableArray alloc] init];
	}
	return self;
}

#pragma mark - Public API

- (BOOL)addUser:(CSUser *)user
{
	BOOL (^identicalusernames)(id, NSUInteger, BOOL *) = ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		if ( [((CSUser *)obj).name isEqualToString:user.name] ) {
			// Do not need to search anymore--stop.
			*stop = YES;
			// Passes test.
			return YES;
		} else {
			// Does not pass test.
			return NO;
		}
	};
	
	// If the user is already in the universe.
	if ( [_users containsObject:user] ) {
		return NO; // Failure.
	}
	
	// If a user already has the same name.
	if ( [_users indexOfObjectPassingTest:identicalusernames] ) {
		return NO; // Failure.
	}
	
	// Add user to the universe.
	[_users addObject:user];
	
	// Success.
	return YES;
}

- (BOOL)removeUser:(CSUser *)user
{
	// If user is in the universe.
	if ( [_users containsObject:user] ) {
		// Remove user from universe.
		[_users removeObject:user];
		return YES;
	}
	
	// User does not exist in the universe.
	return NO;
}

- (CSUser *)findUserWithName:(NSString *)name
{
	// Iterate over all users.
	for ( CSUser *u in _users ) {
		if ( [u.name isEqualToString:name] ) {
			return u;
		}
	}
	
	// Return nil, since no user has been found.
	return nil;
}

- (BOOL)sendMessage:(NSString *)message toUserWithName:(NSString *)name sender:(CSUser *)sender
{
	// Find the user.
	CSUser *receiver = [self findUserWithName:name];
	
	// Compose the full message to send.
	NSString *fullMessage = [CSUserUniverse fullMessageStringFromBaseMessage:message fromUser:sender];
	
	// Send the message to the receiving user.
	return [receiver sendMessage:fullMessage];
}

- (void)broadcastMessage:(NSString *)message sender:(CSUser *)sender
{
	// The full message to send to all users.
	NSString *fullMessage = [CSUserUniverse fullMessageStringFromBaseMessage:message fromUser:sender];
	
	// Iterate over all users in the universe.
	for ( CSUser *u in _users ) {
		// Send the message.
		[u sendMessage:fullMessage];
	}
}

#pragma mark - Private API

+ (NSString *)fullMessageStringFromBaseMessage:(NSString *)message fromUser:(CSUser *)sender
{
	// Create a full message in the format:
	// Username: message
	NSString *fullMessage = [NSString stringWithFormat:@"%@: %@", sender.name, message];
	return fullMessage;
}

   
@end
