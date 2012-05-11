/* 
 Copyright 2012 Javier Soto (ios@javisoto.es)
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. 
 */

#import "JSBaseViewController.h"

#import <CoreData/CoreData.h>

#import "JSProgressHUD.h"

#define kDefaultViewKeyboardSlideSpeed 0.3f

@interface JSBaseViewController ()
{
    BOOL waitViewVisible;
    
    BOOL _shouldListenForKeyboardNotifications;
}

@property (nonatomic, retain) JSProgressHUD *waitView;

- (void)setUp;

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden withNotificationInfo:(NSDictionary *)notificationInfo;
@end

@implementation JSBaseViewController

@synthesize waitView = _waitView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setUp];
    }
    
    return self;
}

- (id)init
{
    return [self initWithNibName:nil bundle:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUp];
}

- (void)setUp
{
	// Empty default implementation
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	NSLog(@"[%@] viewWillAppear:", NSStringFromClass([self class])); // Log each viewWillAppear. Very useful for debugging.
    
    if (_shouldListenForKeyboardNotifications)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowOrHideNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowOrHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    viewVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    viewVisible = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_shouldListenForKeyboardNotifications)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Only allow portrait by default in all VCs
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext
{
    NSAssert(NO, @"You need to provide your own managedObjectContext by implementing this method");
    return nil;
}

#pragma mark - Wait View

- (JSProgressHUD *)waitView
{
    if (!_waitView)
    {
        _waitView = [[JSProgressHUD progressViewInView:self.view] retain];
    }
    
    return _waitView;
}

- (void)showWaitView
{
    [self.waitView showWithStatus:nil];
    waitViewVisible = YES;
}

- (void)showWaitViewAndDimScreen
{
    [self.waitView showWithStatus:nil maskType:JSProgressHUDMaskTypeClear];
    waitViewVisible = YES;
}

- (void)showWaitViewWithMessage:(NSString*)message
{
    [self.waitView showWithStatus:message];
    waitViewVisible = NO;
}

- (void)hideWaitView
{
    [self.waitView dismiss];
    waitViewVisible = NO;
}

- (void)hideWaitViewWithSuccessMessage:(NSString *)message
{
    [self.waitView dismissWithSuccess:message];
    waitViewVisible = NO;
}

- (void)hideWaitViewWithErrorMessage:(NSString *)message
{
    [self.waitView dismissWithError:message];
    waitViewVisible = NO;
}

#pragma mark - Adjusting the view for the keyboard

- (void)animateViewWithKeyboardUpDirection:(BOOL)up distance:(float)distance animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)curve
{
    const int movementDistance = distance;
    
	int movement = (up ? -movementDistance : movementDistance);
    
    [UIView animateWithDuration:duration delay:0.0 options:curve | UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.view setFrame:CGRectOffset(self.view.frame, 0, movement)];
    } completion:NULL];
}

- (void)registerForKeyboardNotifications
{
    _shouldListenForKeyboardNotifications = YES;
}

- (void)keyboardShowOrHideNotification:(NSNotification *)notification
{
    BOOL keyboardHidden = [notification.name isEqualToString:UIKeyboardWillHideNotification];
    NSDictionary *info = [notification userInfo];
    
    [self keyboardWillBecomeHidden:keyboardHidden withNotificationInfo:info];
}

- (void)defaultKeyboardAppereanceBehaviourForKeyboardHidden:(BOOL)keyboardHidden animationDuration:(NSTimeInterval)animationDuration curve:(UIViewAnimationCurve)curve keyboardHeight:(CGFloat)keyboardHeight
{    
    [self animateViewWithKeyboardUpDirection:!keyboardHidden distance:keyboardHeight animationDuration:animationDuration animationCurve:curve];
}

- (void)viewWillAdjustForKeyboardHidden:(BOOL)keyboardHidden keyboardHeight:(CGFloat)keyboardHeight
{
    // Empty default implementation
}

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden withAnimationDuration:(NSTimeInterval)animationDuration curve:(UIViewAnimationCurve)curve keyboardHeight:(CGFloat)_keyboardHeight
{
    curve |= UIViewAnimationOptionBeginFromCurrentState;
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:curve animations:^{        
        CGFloat keyboardHeight = keyboardHidden ? 0.0 : _keyboardHeight;
        
        [self viewWillAdjustForKeyboardHidden:keyboardHidden keyboardHeight:keyboardHeight];        
    } completion:NULL];
}

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden withNotificationInfo:(NSDictionary *)notificationInfo
{
    UIViewAnimationCurve animationCurve; [[notificationInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    CGRect keyboardFrameAtEndOfAnimation; [[notificationInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrameAtEndOfAnimation];
    CGFloat keyboardHeight = keyboardFrameAtEndOfAnimation.size.height;
    
    NSTimeInterval animationDuration = [[notificationInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self keyboardWillBecomeHidden:keyboardHidden withAnimationDuration:animationDuration curve:animationCurve keyboardHeight:keyboardHeight];
}

#pragma mark - Memory Management

- (void)dealloc
{
	NSLog(@"[%@] dealloc:", NSStringFromClass([self class])); // Log each dealloc. Very useful for debugging.
    
    [_waitView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
