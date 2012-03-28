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

#import "JSBaseCoreDataBackedTableViewController.h"

@interface JSBaseCoreDataTableViewController () <NSFetchedResultsControllerDelegate>

@end

@implementation JSBaseCoreDataTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize shouldCacheFetchedObjects = _shouldCacheFetchedObjects;

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tv configureCell:(UITableViewCell *)cell forManagedObject:(NSManagedObject *)object
{
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tv configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tv configureCell:cell forManagedObject:[self objectAtIndexPath:indexPath]];
}

#pragma mark - Lazy loading of Core Data objects

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:self.managedObjectContext sectionNameKeyPath:[self sectionNameKeyPath] cacheName:_shouldCacheFetchedObjects ? NSStringFromClass([self class]) : nil];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

- (void)recreateFetchedResultsController
{
    [_fetchedResultsController release];
    _fetchedResultsController = nil;
    
    NSFetchedResultsController *newFetchedResultsController = self.fetchedResultsController;
    #pragma unused(newFetchedResultsController)
}

- (NSFetchRequest *)fetchRequest
{
    NSLog(@"Unimplemented required method %s in class %@", (char *)_cmd, NSStringFromClass([self class]));
    [self doesNotRecognizeSelector:_cmd];
    
    return nil;
}

- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSString *)sectionNameKeyPath
{
    return nil;
}

- (UITableViewRowAnimation)rowAnimationForChangeType:(NSFetchedResultsChangeType)changeType
{
    return UITableViewRowAnimationNone;
}

- (UITableViewRowAnimation)sectionAnimationForChangeType:(NSFetchedResultsChangeType)changeType
{
    return [self rowAnimationForChangeType:changeType];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{    
    UITableViewRowAnimation animation = [self rowAnimationForChangeType:type];
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:animation];
            break;
        case NSFetchedResultsChangeMove:
            if ([self.tableView respondsToSelector:@selector(moveRowAtIndexPath:toIndexPath:)]) { // iOS5+ only
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            } else {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:animation];
            }             
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
            break;
    }    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSIndexSet *indexSetWithSectionIndex = [NSIndexSet indexSetWithIndex:sectionIndex];
    
    UITableViewRowAnimation animation = [self sectionAnimationForChangeType:type];
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:indexSetWithSectionIndex withRowAnimation:animation];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:indexSetWithSectionIndex withRowAnimation:animation];
            break;
    }    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Memory Management

- (void)dealloc
{
    [_fetchedResultsController release];
    
    [super dealloc];
}

@end
