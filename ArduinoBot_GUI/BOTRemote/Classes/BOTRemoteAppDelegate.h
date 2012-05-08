//
//  BOTRemoteAppDelegate.h
//  BOTRemote
//
//  Created by nix on 23/12/10.
//  Copyright Epitech 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BTstack/BTDevice.h>

@interface BOTRemoteAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
