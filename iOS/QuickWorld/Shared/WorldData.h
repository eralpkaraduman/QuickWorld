//
//  WorldData.h
//  QuickWorld
//
//  Created by Eralp Karaduman on 15/10/14.
//  Copyright (c) 2014 eralpkaraduman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface Question : NSObject
@property NSString *question;
@property NSArray *answers;
@property (assign) NSInteger correctIndex;
@end

@interface WorldData : NSObject
+(void)capitalsWithCompletionBlock:(void (^)(Question *question))block;
@end
