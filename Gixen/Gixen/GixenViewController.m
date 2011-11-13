//
//  GixenViewController.m
//  Gixen
//
//  Created by Reuben Dennison on 11/11/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GixenViewController.h"
#import "TabBar.h"

@implementation GixenViewController

@synthesize logIn;

CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

- (IBAction)LogMeIn:(id)sender{
    NSString *username = [NSString stringWithString:usernameField.text];
    NSString *password = [NSString stringWithString:passwordField.text];
    
    if([username isEqualToString:@""] || [password isEqualToString:@""])
    {
        NSLog(@"Please Enter Login Details");
    }else{
    
    NSString *myURL = [ NSString stringWithFormat: @"https://www.gixen.com/api.php?username=%@&password=%@&notags=1", username, password]; 
    
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:myURL]]; 
    
    NSString *Str = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding: NSUTF8StringEncoding]; 
    if([Str isEqualToString:@""]){

        //load new screen
        //add username and password to plist
        NSArray *values = [[NSArray alloc] initWithObjects:username,password, nil];
        [values writeToFile:[self saveFilePath] atomically:YES];
        [values release];
        [self addSubView:TabBar];
    }else{
        NSLog(@"%@", Str);
    }
    }

}
- (void)tabbarViewControllerDidFinish:(TabBar *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}
- (NSString *)saveFilePath{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"];
}
- (IBAction)makeKeyboardGoAway:(id)sender{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == usernameField) {
        [passwordField becomeFirstResponder];
    } else if (textField == passwordField) {
        [textField resignFirstResponder];
        [self LogMeIn:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0){
        heightFraction = 0.0;
    }else if (heightFraction > 1.0){
        heightFraction = 1.0;
    }
    
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSString *myPath = [self saveFilePath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
    
    if(fileExists){
        NSArray *values = [[NSArray alloc] initWithContentsOfFile:myPath];
        [usernameField setText:[values objectAtIndex:0]];
        [passwordField setText:[values objectAtIndex:1]];
        [values release];
    }

    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
