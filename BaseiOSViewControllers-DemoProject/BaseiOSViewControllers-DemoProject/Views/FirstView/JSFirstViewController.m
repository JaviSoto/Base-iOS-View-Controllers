//
//  JSFirstViewController.m
//  BaseiOSViewControllers-DemoProject
//
//  Created by Javier Soto on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSFirstViewController.h"

#import "JSFakeRequest.h"

@interface JSFirstViewController () <UITextFieldDelegate>
{
    CGFloat textFieldInitialYPosition;
}
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation JSFirstViewController
@synthesize searchTextField;
@synthesize resultLabel;

// This method is called no matter how we instantiate the controller
- (void)setUp
{
    self.title = @"First";
    
    // Make the view automatically adjust so the text field is still visible with the keyboard
    [self registerForKeyboardNotifications];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textFieldInitialYPosition = self.searchTextField.frame.origin.y;
}

#pragma mark - "Request" logic

- (void)startSearchWithString:(NSString *)searchString
{
    /* Only start if there's not a search in progress */
    
    if (!searching)
    {
        searching = YES;
        
        self.resultLabel.text = @"";
        
        // Show the progress HUD
        [self showWaitViewWithMessage:[NSString stringWithFormat: @"Searching for \"%@\"", searchString]];
        
        [JSFakeRequest makeFakeRequestWithCallback:^(BOOL success) {
            if (success)
            {
                [self hideWaitView];
                
                self.resultLabel.text = [NSString stringWithFormat:@"Found: \"%@\"", searchString];
            }
            else
            {
                // Hide the progress HUD with an error message
                [self hideWaitViewWithErrorMessage:[NSString stringWithFormat:@"Didn't find any results for \"%@\"", searchString]];
            }
            
            searching = NO;
        }];
    }
}

#pragma mark - Keyboard Management

- (void)viewWillAdjustForKeyboardHidden:(BOOL)keyboardHidden keyboardHeight:(CGFloat)keyboardHeight
{
    CGRect textFieldFrame = self.searchTextField.frame;
    textFieldFrame.origin.y = keyboardHidden ? textFieldInitialYPosition : (textFieldInitialYPosition - (keyboardHeight / 2));
    self.searchTextField.frame = textFieldFrame;
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    /* Return NO if there's a search in progress. The searching boolean is defined in JSBaseViewController for all controllers to use */
    
    return !searching;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0)
        [self startSearchWithString:textField.text];
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Memory Management

- (void)viewDidUnload
{
    [self setResultLabel:nil];
    [self setSearchTextField:nil];
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [resultLabel release];
    [searchTextField release];
    
    [super dealloc];
}

@end
