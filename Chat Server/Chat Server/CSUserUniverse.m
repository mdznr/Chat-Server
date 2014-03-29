//
//  CSUserUniverse.m
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "CSUserUniverse.h"

@interface CSUserUniverse () {
	NSMutableArray *users;
}

/// All the users that exist in this universe.
@property NSMutableArray *users;

@end

#pragma mark -

@implementation CSUserUniverse

@synthesize users;

- (id)init
{
	self = [super init];
	if ( self ) {
		[self setUsers:[[NSMutableArray alloc] init]];
	}
	return self;
}


#pragma mark - Public API

- (BOOL)addUser:(CSUser *)user
{
	// If the user is already in the universe.
	if ( [[self users] containsObject:user] ) {
		return NO; // Failure.
	}
	
	// If a user already has the same name.
	if ( [self findUserWithName:[user username]] != nil ) {
		return NO; // Failure.
	}
	
	// Add user to the universe.
	[[self users] addObject:user];
	
	// Success.
	return YES;
}

- (BOOL)removeUser:(CSUser *)user
{
	// If user is in the universe.
	if ( [[self users] containsObject:user] ) {
		// Remove user from universe.
		[[self users] removeObject:user];
		return YES;
	}
	
	// User does not exist in the universe.
	return NO;
}

- (CSUser *)findUserWithName:(NSString *)name
{
	// Iterate over all users.
	for ( CSUser *u in self.users ) {
		if ( [[u username] isEqualToString:name] ) {
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
	for ( CSUser *u in self.users ) {
		// Send the message.
		[u sendMessage:fullMessage];
	}
}

#pragma mark - Private API

+ (NSString *)fullMessageStringFromBaseMessage:(NSString *)message fromUser:(CSUser *)sender
{
	// Create a full message in the format:
	// username: message
	NSString *fullMessage = [NSString stringWithFormat:@"%@: %@", [sender username], message];
	return fullMessage;
}

   
@end
