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

#pragma mark - Private Properties

/// The file descriptor the user can be contacted on.
@property (nonatomic) int fd;

/// Name property is readwrite internally.
@property (readwrite) NSString *name;

@end


#pragma mark -

@implementation CSUser

- (NSString *)description
{
	return [NSString stringWithFormat:@"Name: %@", self.name];
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"Name: %@; fd: %d", self.name, self.fd];
}

#pragma mark - Initialization

+ (instancetype)userWithName:(NSString *)name andFileDescriptor:(int)fd
{
	CSUser *newUser = [[CSUser alloc] init];
	newUser.name = name;
	newUser.fd = fd;
	return newUser;
}


#pragma mark - Public API

- (BOOL)sendMessage:(NSString *)message
{
	ssize_t send_client_n = send(_fd, [message UTF8String], [message length], 0);
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
#warning close the connection.
}

@end
