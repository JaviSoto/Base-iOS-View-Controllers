//
//  JSCreateToDoViewController.m
//  BaseiOSViewControllers-DemoProject
//
//  Created by Javier Soto on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSCreateToDoViewController.h"

#import "ToDo.h"

@interface JSCreateToDoViewController () <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain, nonatomic) IBOutlet UITextField *titleTextField;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (nonatomic, retain, readwrite) NSManagedObjectContext *managedObjectContext;
@end

@implementation JSCreateToDoViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize navigationBar = _navigationbar;
@synthesize titleTextField = _titleTextField;
@synthesize descriptionTextView = _descriptionTextView;

- (id)initWithManageObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if ((self = [super init]))
    {
        self.managedObjectContext = managedObjectContext;
    }
    
    return self;
}

#pragma mark - Actions

- (IBAction)doneButtonPressed
{
    ToDo *newToDo = [NSEntityDescription insertNewObjectForEntityForName:@"ToDo" inManagedObjectContext:self.managedObjectContext];
    
    newToDo.title = self.titleTextField.text;
    newToDo.desc = self.descriptionTextView.text;
    
    [self.managedObjectContext save:nil];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.descriptionTextView becomeFirstResponder];
    
    return YES;
}

#pragma mark - Memory Management

- (void)viewDidUnload
{
    [self setTitleTextField:nil];
    [self setDescriptionTextView:nil];
    
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [_managedObjectContext release];
    [_titleTextField release];
    [_descriptionTextView release];
    
    [_navigationbar release];
    [super dealloc];
}

@end
