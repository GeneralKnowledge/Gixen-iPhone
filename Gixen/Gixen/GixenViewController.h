//
//  GixenViewController.h
//  Gixen
//
//  Created by Reuben Dennison on 11/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabBar.h"
#import <UIKit/UIKit.h>

@interface GixenViewController : UIViewController {
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
}

@property(nonatomic,retain) UIButton *logIn;

- (NSString *)saveFilePath;
- (IBAction)LogMeIn:(id)sender;
- (IBAction)makeKeyboardGoAway:(id)sender;

@end
