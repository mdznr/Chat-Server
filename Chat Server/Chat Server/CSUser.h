//
//  User.h
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

@class CSUserUniverse;

@interface CSUser : NSObject {
	NSString *username;
	int fd;
	CSUserUniverse __weak *universe;
}

/// Create a user with a particular name and file descriptior.
/// @param username The name the user goes by.
/// @param fd The file descriptor that the user can be contacted on.
/// @return A new user.
+ (id)userWithUsername:(NSString *)username andFileDescriptor:(int)fd;

/// The name of the user.
@property NSString *username;

/// The file descriptor the user can be contacted on.
@property int fd;

/// The universe the user is in.
@property CSUserUniverse __weak *universe;

/// Send the receiving user a message.
/// @param message The message to send to the user.
/// @return The success status of the sending of the message.
- (BOOL)sendMessage:(NSString *)message;

/// Send an outgoing message to another user.
/// @param message The outgoing message to send to another user.
/// @param name The name of the user to send the message to.
/// @return The success status of the sending of the message.
- (BOOL)sendOutgoingMessage:(NSString *)message toUserWithName:(NSString *)name;

/// Broadcast a message.
/// @param message The message to broadcast.
- (void)broadcastMessage:(NSString *)message;

@end
