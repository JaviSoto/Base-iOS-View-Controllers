//
//  JSThirdViewController.m
//  BaseiOSViewControllers-DemoProject
//
//  Created by Javier Soto on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSThirdViewController.h"

#import "JSToDoCell.h"

#import "JSCreateToDoViewController.h"

@interface JSThirdViewController ()

@end

@implementation JSThirdViewController

#pragma mark - Table View Methods

- (void)setUp
{
    self.title = @"Third";
    
    self.cellNibName = [JSToDoCell reuseIdentifier];
}

#pragma mark - Table View Methods

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"ToDo" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetchRequest;
}

- (UITableViewCell *)tableView:(UITableView *)tv configureCell:(UITableViewCell *)cell forManagedObject:(NSManagedObject *)object
{
    JSToDoCell *toDoCell = (JSToDoCell *)cell;
    
    [toDoCell setToDo:(ToDo *)object]; // Cool, huh?
    
    return toDoCell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *objectToRemove = [self objectAtIndexPath:indexPath];

    [self.managedObjectContext deleteObject:objectToRemove];
}

#pragma mark - Actions

- (IBAction)addToDoButtonPressed
{
    JSCreateToDoViewController *createToDo = [[JSCreateToDoViewController alloc] initWithManageObjectContext:self.managedObjectContext];
    [self.tabBarController presentModalViewController:createToDo animated:YES];
    [createToDo release];
}

@end
