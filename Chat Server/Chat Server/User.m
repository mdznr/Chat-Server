//
//  User.m
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "User.h"

#include <sys/socket.h>

@interface User ()

#pragma mark - Private Properties

/// The file descriptor the user can be contacted on.
@property (nonatomic) int fd;

@end


#pragma mark -

@implementation User

#pragma mark - Initialization

+ (instancetype)userWithName:(NSString *)name andFileDescriptor:(int)fd
{
	User *newUser = [[User alloc] init];
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
	
	return YES;
}


#pragma mark - Deallocation

- (void)dealloc
{
#warning close the connection.
}

@end
