//
//  User.m
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "CSUser.h"
#import "CSUserUniverse.h"

#include <sys/socket.h>

#pragma mark -

@implementation CSUser

@synthesize username, fd, universe;

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@", [self username]];
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"{Name: %@; fd: %d}", [self username], [self fd]];
}


#pragma mark - Initialization

+ (id)userWithUsername:(NSString *)username andFileDescriptor:(int)fd
{
	CSUser *newUser = [[CSUser alloc] init];
	[newUser setUsername:username];
	[newUser setFd:fd];
	return newUser;
}


#pragma mark - Incoming Message

- (BOOL)sendMessage:(NSString *)message
{
	ssize_t send_client_n = send([self fd], [message UTF8String], [message length], 0);
	if ( send_client_n < [message length] ) {
		perror("send()");
		return NO;
	}
	
	return YES;
}


#pragma mark - Outgoing Message

- (BOOL)sendOutgoingMessage:(NSString *)message toUserWithName:(NSString *)name
{
	return [[self universe] sendMessage:message toUserWithName:name sender:self];
}

- (void)broadcastMessage:(NSString *)message
{
	[[self universe] broadcastMessage:message sender:self];
}


#pragma mark - Deallocation

- (void)dealloc
{
//	[super dealloc];
#warning close the connection.
}

@end
