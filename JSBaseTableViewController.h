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
#import "EGORefreshTableHeaderView.h"

@interface JSBaseTableViewController : JSBaseViewController <UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate>

@property (nonatomic, retain, readonly) IBOutlet UITableView *tableView;

/* Default: NO. Set to yes in - setUp to automatically have pull to refresh UI in your table */
@property (nonatomic, assign) BOOL tableHasPullToRefresh;
/* Default: NO. Set to yes to get - loadMoreItemsAfterTheLastOne calls when the user scrolls to the end of the table */
@property (nonatomic, assign) BOOL tableHasInfiniteScrolling;
/* Default: NO */
@property (nonatomic, assign) BOOL clearsSelectionOnViewDidAppear;

/* Set this in - setUp to the appropiate name of your cell nib file */
@property (nonatomic, copy) NSString *cellNibName;

/* Implement this method to respond to drag to refresh events */
- (void)reloadTableViewDataSource;
/* Call this method when the drag to refresh load has finished */
- (void)doneLoadingTableViewData;

/* Implement this method to load more items when the user approaches the last row (only called if tableHasInfiniteScrolling is set to YES) */
- (void)loadMoreItemsAfterTheLastOne;

/* Implement this method and make the appropiate changes to the passed cell object. cellNibName has to be set! */
- (UITableViewCell *)tableView:(UITableView *)tv configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Keyboard Management. Implement the needed
/* Return a UIView to automatically have it *stick* on top of the keyboard animatically */
- (UIView *)keyboardAuxView;

/* Aux method for tables with more than one element per row */
- (NSRange)rangeOfElementsForCellAtIndexPath:(NSIndexPath *)indexPath elementsPerRow:(NSUInteger)elementsPerRow totalElements:(NSUInteger)totalElements;

@end
