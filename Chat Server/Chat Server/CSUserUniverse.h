//
//  CSUserUniverse.h
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CSUser.h"

@class CSUserUniverse;

@interface CSUserUniverse : NSObject {
	NSMutableArray *users;
}

/// All the users that exist in this universe.
@property (atomic) NSMutableArray *users;

#pragma mark - Managing Users

/// Add a user to the universe.
/// @param user The user to add.
/// @return Whether or not the user could be added.
- (BOOL)addUser:(CSUser *)user;

/// Remove a suer from the universe.
/// @param user The user to remove.
/// @return Whether or not the user exists in the universe and was successfully removed.
- (BOOL)removeUser:(CSUser *)user;


#pragma mark - Looking Up Users

/// Find a user with a particular name.
/// @param name The name of the user to find in the universe.
/// @return The user with the specified name or @c nil if a user could not be found.
- (CSUser *)findUserWithName:(NSString *)name;

///	Get a list of users to return to a client.
///	@return A string representing all the users that are logged in.
- (NSString *)listOfUsers;


#pragma mark - Sending Messages and Broadcasting

/// Send a message from one user to another with a specific name.
/// @param message The message to send.
/// @param name The name of the user to send the message to.
/// @param sender The user sending the message.
/// @return Whether or not the message could successfully be sent to the user with the given name.
- (BOOL)sendMessage:(NSString *)message toUserWithName:(NSString *)name sender:(CSUser *)sender;

/// Broadcast a message to all users in the universe.
/// @param message The message to broadcast.
/// @param sender The user broadcasting the message.
- (void)broadcastMessage:(NSString *)message sender:(CSUser *)sender;

@end
