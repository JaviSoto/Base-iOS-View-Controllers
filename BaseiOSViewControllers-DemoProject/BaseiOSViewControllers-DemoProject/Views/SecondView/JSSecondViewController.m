//
//  JSSecondViewController.m
//  BaseiOSViewControllers-DemoProject
//
//  Created by Javier Soto on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSSecondViewController.h"

#import "JSChatCell.h"

#import "JSFakeRequest.h"

@interface JSSecondViewController () <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIView *keyboardAuxView;
@property (retain, nonatomic) IBOutlet UITextField *chatTextField;

@property (nonatomic, readonly) NSMutableArray *chatMessages;
@end

@implementation JSSecondViewController
@synthesize chatMessages = _chatMessages;
@synthesize keyboardAuxView = _keyboardAuxView;
@synthesize chatTextField = _chatTextField;

- (void)setUp
{
    self.title = @"Second";
    
    // Just by setting this, the cell will be created for us automatically
    self.cellNibName = [JSChatCell reuseIdentifier]; // By setting it like this instead of a plain static string, we make sure a refactor changes this too
    
    // Just this line of code adds pull to refresh
    self.tableHasPullToRefresh = YES;
    
    _chatMessages = [[NSMutableArray alloc] init];
    
    // The table will automatically shrink and stretch with the keyboard
    [self registerForKeyboardNotifications];
}

#pragma mark - Table View Methods

- (NSString *)chatMessageAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatMessages objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return self.chatMessages.count;
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JSChatCell heightOfChatCellWithMessage:[self chatMessageAtIndexPath:indexPath]];
}

// We only need to implement this method to customize the table!
- (UITableViewCell *)tableView:(UITableView *)tv configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSChatCell *chatCell = (JSChatCell *)cell;
    
    [chatCell setChatMessage:[self chatMessageAtIndexPath:indexPath]];
    
    return chatCell; // Ain't it amazing how little code this method has...?
}

#pragma mark - Pull To refresh

// This method gets called on us when the user requests to reload the table
- (void)reloadTableViewDataSource
{
    [JSFakeRequest makeFakeRequestWithCallback:^(BOOL success) {
        [self.tableView reloadData];
        
        [self doneLoadingTableViewData]; // Just call this method to tell the pull-to-refresh UI we're done loading
    }];
}

#pragma mark - Keyboard Methods

// Just by implementing this method, the bar will "travel" on top of the keyboard
- (UIView *)keyboardAuxView
{
    return _keyboardAuxView;
}

#pragma mark - Actions

- (IBAction)sendButtonPressed:(id)sender
{
    [self.chatTextField resignFirstResponder];
    
    NSString *chatMessage = self.chatTextField.text;
    
    self.chatTextField.text = @"";
    
    if (chatMessage.length > 0)
    {
        [self showWaitViewWithMessage:@"Sending..."];
        
        [self.chatMessages addObject:chatMessage];
        
        NSIndexPath *indexPathOfRowToAdd = [NSIndexPath indexPathForRow:self.chatMessages.count - 1 inSection:0];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathOfRowToAdd] withRowAnimation:UITableViewRowAnimationLeft];
        
        [JSFakeRequest makeFakeRequestWithCallback:^(BOOL success) {
            
            if (success)
            {                                        
                [self hideWaitView];
            }
            else
            {
                [self hideWaitViewWithErrorMessage:[NSString stringWithFormat:@"Error sending message \"%@\"", chatMessage]];
                self.chatTextField.text = chatMessage;
                
                NSIndexPath *indexPathOfRowToDelete = [NSIndexPath indexPathForRow:[self.chatMessages indexOfObject:chatMessage] inSection:0];
                
                [self.chatMessages removeObject:chatMessage];
                
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathOfRowToDelete] withRowAnimation:UITableViewRowAnimationRight];
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Memory Management

- (void)viewDidUnload
{
    [self setKeyboardAuxView:nil];
    [self setChatTextField:nil];
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [_chatMessages release];
    [_keyboardAuxView release];
    [_chatTextField release];
    
    [super dealloc];
}

@end
