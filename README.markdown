#Components

```
JSBaseViewController
JSBaseTableViewController
JSBaseCoreDataTableViewController
JSBaseTableViewCell
```

#Highlights

- Adjusting your view automatically along with the keyboard.
- Stick a view (like a textfield) on top of the keyboard.
- Progress HUD showing / hiding in all your View Controllers.
- Automatic cell nibs instantiation. Just code what is important.
- Pull to refresh in one line of code.
- Very easily implement tables that show data from Core Data.

#Features

- One generic method to construct your controllers: **forget about implementing the right - initWith, awakeFromNib**... just implement

```objective-c
- (void)setUp;
```

and be sure it will be called once in all cases.

- Easy way to show / hide a flexible **progress HUD** when you make long-running requests from all your View Controllers.

```Objective-c
- (void)showWaitView;
- (void)showWaitViewAndDimScreen;
- (void)showWaitViewWithMessage:(NSString*)message;
- (void)hideWaitView;
- (void)hideWaitViewWithSuccessMessage:(NSString *)message;
- (void)hideWaitViewWithErrorMessage:(NSString *)message;
```

- **Forget about dealing with nib loading**, cell reusing, etc and **implement table views with very little code**. Just set the name of the nib file that corresponds to the cell that the table will use in the setUp method like this:

```Objective-c
- (void)setUp
{
	self.cellNibName = @"MyCellNibFileName";
}
```

and than you can just implement this method to make the necessary adjustments to the cell (which you can cast to your own *UITableViewCell* subclass):

```Objective-c
- (UITableViewCell *)tableView:(UITableView *)tv configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
```

Only requirement is that your cell inherits from [*JSBaseTableViewCell*](https://github.com/JaviSoto/Base-iOS-View-Controllers/blob/master/JSBaseTableViewCell.h).

- Add **pull-to-refresh** to you table view controller just by setting

```Objective-c
self.tableHasPullToRefresh = YES;
```

in your setUp method. And then use these two methods:

```Objective-c
/* Implement this method to respond to drag to refresh events */
- (void)reloadTableViewDataSource;
/* Call this method when the drag to refresh load has finished */
- (void)doneLoadingTableViewData;
```

- Same for table **infinite scrolling** with
       
```Objective-c
self.tableHasInfiniteScrolling = YES;
```

- **Automatically have your view adjusted when the keyboard appears / disappears**. Just by calling

```Objective-c
[self registerForKeyboardNotifications];
```

in your setUp method. If it's a regular view controller, you can implement 

```Objective-c
- (void)animateViewWithKeyboardUpDirection:(BOOL)up distance:(float)distance animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)curve;
```

and create your animation with that data.
If it's a *Table View Controller*, the table will automatically adjust. if you want to provide custom behaviour, you can implement

```Objective-c
- (void)tableViewWillBeResizedToAdjustForKeyboardHidden:(BOOL)keyboardHidden keyboardHeight:(CGFloat)keyboardHeight;
```

which will be called inside the animation block.

- **Have a view stick on top of the keyboard and animate with it** (very convenient for typical chat / comment views). Just implement the method:

```Objective-c
- (UIView *)keyboardAuxView;
```

and return the view that you want to stay on top of the keyboard.

- **Implement tables that show data from Core Data with very little code** (and that are automatically refreshed with changes in them). Inherit from [*JSBaseCoreDataTableViewController*](https://github.com/JaviSoto/Base-iOS-View-Controllers/blob/master/JSBaseCoreDataTableViewController.h) and implement:

```Objective-c
- (NSFetchRequest *)fetchRequest;
```

to return an *NSFetchRequest* object corresponding to the query you want to perform. And then implement this other method that will be called on you:

```Objective-c
- (UITableViewCell *)tableView:(UITableView *)tv configureCell:(UITableViewCell *)cell forManagedObject:(NSManagedObject *)object;
```

- Have all your cells automatically be correctly reused even if you forget to set the reuse identifier in Interface Builder. For this you only need to make your cell classes inherit from [*JSBaseTableViewCell*](https://github.com/JaviSoto/Base-iOS-View-Controllers/blob/master/JSBaseTableViewCell.h).

#Submodules

```
- JSProgressHUD: https://github.com/JaviSoto/JSProgressHUD
- EGOTableViewPullRefresh: https://github.com/enormego/EGOTableViewPullRefresh
```

#Installation

**First** clone the repository:

```bash
$ git clone git@github.com:JaviSoto/Base-iOS-View-Controllers.git
$ cd Base-iOS-View-Controllers
$ git submodule init
$ git submodule update
```

**Second**. Drag the entire folder to your Xcode project.

**Third**. (Optional) Modify the method - (NSManagedObjectContext *)managedObjectContext in [*JSBaseViewController*](https://github.com/JaviSoto/Base-iOS-View-Controllers/blob/master/JSBaseViewController.m) by adding the needed logic to create a NSManagedObjectContext passing your NSPersistantStoreCordinator (ONLY IF YOU WANT TO USE CORE DATA).