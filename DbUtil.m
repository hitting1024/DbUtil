//
//  DbUtil.m
//
//  Created by hitting on 13/09/11.
//  Copyright (c) 2012年 Hit Apps. All rights reserved.
//

#import "DbUtil.h"

#import "Const.h"

@implementation DbUtil

+ (void)checkDB {
    //dbチェック
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath: dbPath] == NO) {
		//dbがないので作成
		NSString *dbTemplatePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
		NSError *err;
		[fileManager copyItemAtPath:dbTemplatePath toPath:dbPath error:&err];
	}
	// バージョンアップ管理
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *version = [defaults stringForKey:@"version"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if(![version isEqualToString:currentVersion]) {
        //バージョンアップ時
    	NSError *err;
        [fileManager removeItemAtPath:dbPath error:&err];
    	NSString *dbTemplatePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
        [fileManager copyItemAtPath:dbTemplatePath toPath:dbPath error:&err];
        //バージョン保存
        [defaults setObject:currentVersion forKey:@"version"];
    }
}

+ (FMDatabase *)getDb:(NSString *)dbName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
	
	FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
	
	if(![db open]) {
		@throw [NSException exceptionWithName:@"DBOpenException" reason:@"couldn't open specified db file" userInfo:nil];
	}
	
	return db;
}

@end
