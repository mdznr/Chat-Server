//
//  User.h
//  Chat Server
//
//  Created by Matt Zanchelli on 3/27/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

@interface User : NSObject

/// Create a user with a particular name and file descriptior.
/// @param name The name the user goes by.
/// @param fd The file descriptor that the user can be contacted on.
/// @return A new user.
+ (instancetype)userWithName:(NSString *)name andFileDescriptor:(int)fd;

/// The name of the user.
@property (strong, nonatomic) NSString *name;

/// Send the receiving user a message.
/// @param message The message to send to the user.
/// @return The success status of the sending of the message.
- (BOOL)sendMessage:(NSString *)message;

@end
