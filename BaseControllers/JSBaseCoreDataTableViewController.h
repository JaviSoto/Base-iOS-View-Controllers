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

#import <CoreData/CoreData.h>

#import "JSBaseTableViewController.h"

@interface JSBaseCoreDataTableViewController : JSBaseTableViewController

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

/* Default: NO */
@property (nonatomic, assign) BOOL shouldCacheFetchedObjects;

/* Required. Implement this method instead of the parent's configureCell to be passed the managed object directly */
- (UITableViewCell *)tableView:(UITableView *)tv configureCell:(UITableViewCell *)cell forManagedObject:(NSManagedObject *)object;

- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath;

/* Optional. Default implementation returns nil */
- (NSString *)sectionNameKeyPath;

/* Required. Return the fetch request from which results the table should be filled */
- (NSFetchRequest *)fetchRequest;

/* Call to perfom the fetch request again */
- (void)reloadData;

/* Call if you need to change the Fetch Request according to user setting (for instance to change the predicate) */
- (void)recreateFetchedResultsController;

/* Optional. Default implementation returns UITableViewRowAnimationNone for all change types. Override if needed. */
- (UITableViewRowAnimation)rowAnimationForChangeType:(NSFetchedResultsChangeType)changeType;
/* Optional. Default implementation returns UITableViewRowAnimationNone for all change types. Override if needed. */
- (UITableViewRowAnimation)sectionAnimationForChangeType:(NSFetchedResultsChangeType)changeType;


@end
