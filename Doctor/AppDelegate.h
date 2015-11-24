//
//  AppDelegate.h
//  Doctor
//
//  Created by xmfish on 15/11/24.
//  Copyright © 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainTabBarViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainTabBarViewController* mainViewController;

+ (UIViewController *)visibleViewController;

@end

