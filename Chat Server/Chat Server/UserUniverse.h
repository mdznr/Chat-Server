//
//  UserUniverse.h
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface UserUniverse : NSObject

#pragma mark - Managing Users

/// Add a user to the universe.
/// @param user The user to add.
/// @return Whether or not the user could be added.
- (BOOL)addUser:(User *)user;

/// Remove a suer from the universe.
/// @param user The user to remove.
/// @return Whether or not the user exists in the universe and was successfully removed.
- (BOOL)removeUser:(User *)user;


#pragma mark - Looking Up Users

/// Find a user with a particular name.
/// @param name The name of the user to find in the universe.
/// @return The user with the specified name or @c nil if a user could not be found.
- (User *)findUserWithName:(NSString *)name;


#pragma mark - Sending Messages and Broadcasting

/// Send a message from one user to another with a specific name.
/// @param message The message to send.
/// @param name The name of the user to send the message to.
/// @param sender The user sending the message.
/// @return Whether or not the message could successfully be sent to the user with the given name.
- (BOOL)sendMessage:(NSString *)message toUserWithName:(NSString *)name sender:(User *)sender;

/// Broadcast a message to all users in the universe.
/// @param message The message to broadcast.
/// @param sender The user broadcasting the message.
- (void)broadcastMessage:(NSString *)message sender:(User *)sender;

@end
