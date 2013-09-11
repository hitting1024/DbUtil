//
//  DbUtil.h
//
//  Created by hitting on 13/09/11.
//  Copyright (c) 2013年 Hit Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"

@interface DbUtil : NSObject

+ (void)checkDB;
+ (FMDatabase *)getDb:(NSString *)dbName;

@end
