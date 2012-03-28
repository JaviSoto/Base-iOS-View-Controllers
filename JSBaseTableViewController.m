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

#import "JSBaseTableViewController.h"

#import "JSBaseTableViewCell.h"

@interface JSBaseTableViewController()
@property (nonatomic, retain, readwrite) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSDate *tableViewLastUpdate;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;

- (void)setUp;

- (void)reloadTableViewDataSource;
@end

@implementation JSBaseTableViewController
@synthesize tableHasPullToRefresh = _tableHasPullToRefresh;
@synthesize tableHasInfiniteScrolling = _tableHasInfiniteScrolling;
@synthesize clearsSelectionOnViewDidAppear = _clearsSelectionOnViewWillAppear;
@synthesize tableView = _tableView;
@synthesize refreshHeaderView;
@synthesize tableViewLastUpdate;

@synthesize cellNibName = _cellNibName, cellNib;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (_tableHasPullToRefresh) 
    {
        if (refreshHeaderView == nil)
        {
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
            view.delegate = self;
            [self.tableView addSubview:view];
            refreshHeaderView = view;
        }
        
        //  update the last update date
        [refreshHeaderView refreshLastUpdatedDate];    
    }
    
    // Set table cell height if the cell sets it:
    CGFloat cellHeight = [NSClassFromString(self.cellNibName) cellHeight];
    
    if (cellHeight != kBaseTableViewCellNoCellHeightSet)
    {
        self.tableView.rowHeight = cellHeight;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.clearsSelectionOnViewDidAppear)
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    }
}

#pragma mark - Table view Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"[%@] Incomplete method implementation: %s.", NSStringFromClass([self class]), (char *)_cmd);
    [self doesNotRecognizeSelector:_cmd];

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tv configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:self.cellNibName];
    
    if (!cell)
    {
        cell = [[self.cellNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    
    return [self tableView:tv configureCell:cell forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableHasInfiniteScrolling)
    {
        NSInteger numberOfRows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        
        BOOL isLastRow = ((indexPath.row + 1) == numberOfRows);
        
        if (isLastRow)
        {
            BOOL allRowsFitInScreen = (self.tableView.rowHeight * numberOfRows) < self.tableView.frame.size.height;
            
            if (!allRowsFitInScreen)
            {
                [self loadMoreItemsAfterTheLastOne];
            }
        }
    }
}

- (NSRange)rangeOfElementsForCellAtIndexPath:(NSIndexPath *)indexPath elementsPerRow:(NSUInteger)elementsPerRow totalElements:(NSUInteger)totalElements
{
    NSUInteger firstIndexAtRow = indexPath.row * elementsPerRow; 
    NSUInteger numberOfRows = ceil(totalElements / (float)elementsPerRow);
    BOOL isLastRow = indexPath.row + 1 == numberOfRows;
    NSUInteger numberOfElementsAtRow = (isLastRow && totalElements % elementsPerRow != 0) ? totalElements % elementsPerRow : elementsPerRow;
    
    NSRange range = NSMakeRange(firstIndexAtRow, numberOfElementsAtRow);
    
    return range;
}

#pragma mark - Data Source Loading / Reloading Methods

- (void)loadMoreItemsAfterTheLastOne
{
    
}

- (void)reloadTableViewDataSource
{
    
}

- (void)doneLoadingTableViewData
{
	searching = NO;
    self.tableViewLastUpdate = [NSDate date];
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
	return searching;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
	return self.tableViewLastUpdate;
}

#pragma mark - Table Cell

- (UINib *)cellNib
{
    if (!cellNib)
    {
        NSAssert(self.cellNibName && ![self.cellNibName isEqualToString:@""], @"Cell nib name not set in controller %@", NSStringFromClass([self class]));
        cellNib = [[UINib nibWithNibName:self.cellNibName bundle:nil] retain];
    }
    
    return cellNib;
}

#pragma mark - Keyboard Management

- (void)tableViewWillBeResizedToAdjustForKeyboardHidden:(BOOL)keyboardHidden keyboardHeight:(CGFloat)keyboardHeight
{
	// Empty default implementation
}

- (UIView *)keyboardAuxView
{
    return nil;
}

- (CGFloat)tableViewHeight
{
    return self.view.frame.size.height - [self keyboardAuxView].frame.size.height;
}

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden withAnimationDuration:(NSTimeInterval)animationDuration curve:(UIViewAnimationCurve)curve keyboardHeight:(CGFloat)_keyboardHeight
{   
    curve |= UIViewAnimationOptionBeginFromCurrentState;
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:curve animations:^{        
        CGFloat keyboardHeight = keyboardHidden ? 0.0 : _keyboardHeight;
        
        [self tableViewWillBeResizedToAdjustForKeyboardHidden:keyboardHidden keyboardHeight:keyboardHeight];
        
        UIView *keyboardAuxView = [self keyboardAuxView];
        
        CGRect keyboardAuxViewFrame = [self keyboardAuxView].frame;        
        keyboardAuxViewFrame.origin.y = self.view.frame.size.height - keyboardHeight - keyboardAuxViewFrame.size.height;
        keyboardAuxView.frame = keyboardAuxViewFrame;        
        
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.size.height = [self tableViewHeight] - keyboardHeight;
        self.tableView.frame = tableViewFrame;
    } completion:NULL];
}

#pragma mark - Memory Management

- (void)viewDidUnload
{    
    [refreshHeaderView release];
    refreshHeaderView = nil;
    self.tableView = nil;
    
    self.cellNib = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [_tableView release];
    [refreshHeaderView release];
    [cellNib release];
    [_cellNibName release];
    
    [tableViewLastUpdate release];
    
    [super dealloc];
}

@end