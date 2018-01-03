//
//  AppDelegate.m
//  WaxPathStudy
//
//  Created by chuchengpeng on 2017/12/25.
//  Copyright © 2017年 chuchengpeng. All rights reserved.
//

#import "AppDelegate.h"
#import <wax.h>
#import "ViewController.h"
#import "ZipArchive.h"

#define wax_file_url @"http://localhost/patch.zip"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    wax_startWithNil();
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *luoFP = [doc stringByAppendingPathComponent:@"lua"];
    NSString *pp = [[NSString alloc ] initWithFormat:@"%@/?.lua;%@/?/init.lua;", luoFP, luoFP];
    setenv(LUA_PATH, [pp UTF8String], 1);
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"BlockExample" ofType:@"lua"];
//    int i = wax_runLuaFile(path.UTF8String);
//    if (i) {
//        NSLog(@"error: %s", lua_tostring(wax_currentLuaState(), -1));
//    }
   // [self zipToFile];
    // Override point for customization after application launch.
    return YES;
}



- (void)zipToFile {
   NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wax_file_url]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [doc stringByAppendingString:@"patch.zip"];
            [data writeToFile:filePath atomically:YES];
            NSString *luoFP = [doc stringByAppendingPathComponent:@"lua"];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:luoFP error:NULL];
            BOOL isCreate = [fm createDirectoryAtPath:luoFP withIntermediateDirectories:YES attributes:nil error:NULL];
            if (isCreate) {
                ZipArchive *zip = [ZipArchive new];
                [zip UnzipOpenFile:filePath];
                [zip UnzipFileTo:luoFP overWrite:YES];
                NSString *pp = [[NSString alloc ] initWithFormat:@"%@/?.lua;%@/?/init.lua;", luoFP, luoFP];
                setenv(LUA_PATH, [pp UTF8String], 1);
                wax_start("patch", nil);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.window.rootViewController = [[ViewController alloc] init];
                    [self.window makeKeyAndVisible];
                });
               
            }
        }
    }];
    [task resume];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
