//
//  User.m
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "CSUser.h"

#include <sys/socket.h>

@interface CSUser ()

/// The file descriptor the user can be contacted on.
@property int fd;

@end


#pragma mark -

@implementation CSUser

@synthesize username, fd;

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


#pragma mark - Properties

- (NSString *)username
{
	return username;
}

- (void)setUsername:(NSString *)x
{
	username = x;
}

- (int)fd
{
	return fd;
}

- (void)setFd:(int)x
{
	fd = x;
}


#pragma mark - Public API

- (BOOL)sendMessage:(NSString *)message
{
	ssize_t send_client_n = send([self fd], [message UTF8String], [message length], 0);
	if ( send_client_n < [message length] ) {
		perror("send()");
		return NO;
	}
	
	return YES;
}


#pragma mark - Private API

- (BOOL)sendOutgoingMessage:(NSString *)message toUserWithName:(NSString *)name
{
#warning How to send outgoing message?
	return YES;
}


#pragma mark - Deallocation

- (void)dealloc
{
//	[super dealloc];
#warning close the connection.
}

@end
