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

#import <UIKit/UIKit.h>

#define kProgressViewDismissAfterSeconds 1.5f
#define kWaitViewDismissAfterSeconds 1.0f

@interface JSBaseViewController : UIViewController
{
	/* Useful to prevent multiple simultaneous requests */
    BOOL searching;
    
    BOOL viewVisible;
}

/* You can get a managedObjectContext for your controller just by accessing here */
@property (nonatomic, readonly, retain) NSManagedObjectContext *managedObjectContext;

/* Optional. Implement if you want to return a different managed object ctx other than the default given to you */
- (NSManagedObjectContext *)managedObjectContext;

/* Implement this method for object inizialization instead of init's or awakeFromNib. It will be called from any of them */
- (void)setUp;

/* Wait view show and hide methods */
- (void)showWaitView;
- (void)showWaitViewAndDimScreen;
- (void)showWaitViewWithMessage:(NSString*)message;
- (void)hideWaitView;
- (void)hideWaitViewWithSuccessMessage:(NSString *)message;
- (void)hideWaitViewWithErrorMessage:(NSString *)message;

#pragma mark - Keyboard Management. Implement the needed
/* View resizing auto management with keyboard notifications */
 - (void)registerForKeyboardNotifications; // You should call this in -setUp

- (void)animateViewWithKeyboardUpDirection:(BOOL)up distance:(float)distance animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)curve;
- (void)defaultKeyboardAppereanceBehaviourForKeyboardHidden:(BOOL)keyboardHidden animationDuration:(NSTimeInterval)animationDuration curve:(UIViewAnimationCurve)curve keyboardHeight:(CGFloat)keyboardHeight;

/* Overwrite this method to implement custom behaviour. Call defaultKeyboardAppereanceBehaviourForKeyboardHidden:animationDuration:curve:keyboardHeight: for inside for a default behaviour (moving up the whole view keyboardHeight pixels) */
- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden withAnimationDuration:(NSTimeInterval)animationDuration curve:(UIViewAnimationCurve)curve keyboardHeight:(CGFloat)keyboardHeight;

@end
