//
//  GixenAppDelegate.h
//  Gixen
//
//  Created by Reuben Dennison on 11/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GixenViewController;

@interface GixenAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet GixenViewController *viewController;

@end
