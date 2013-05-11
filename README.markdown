<!-- MacBuildServer Install Button -->
<div class="macbuildserver-block">
    <a class="macbuildserver-button" href="http://macbuildserver.com/project/github/build/?xcode_project=BaseiOSViewControllers-DemoProject%2FBaseiOSViewControllers-DemoProject.xcodeproj&amp;target=BaseiOSViewControllers-DemoProject&amp;repo_url=git%3A%2F%2Fgithub.com%2FJaviSoto%2FBase-iOS-View-Controllers.git&amp;build_conf=Release" target="_blank"><img src="http://com.macbuildserver.github.s3-website-us-east-1.amazonaws.com/button_up.png"/></a><br/><sup><a href="http://macbuildserver.com/github/opensource/" target="_blank">by MacBuildServer</a></sup>
</div>
<!-- MacBuildServer Install Button -->

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

### - One generic method to construct your controllers:
Forget about implementing the right - initWith, awakeFromNib... just implement

```objective-c
- (void)setUp;
```

and be sure it will be called once in all cases.

### - Easy way to show / hide a flexible **progress HUD**
Very handy for when you make long-running requests from any view controller.

```Objective-c
- (void)showWaitView;
- (void)showWaitViewAndDimScreen;
- (void)showWaitViewWithMessage:(NSString*)message;
- (void)hideWaitView;
- (void)hideWaitViewWithSuccessMessage:(NSString *)message;
- (void)hideWaitViewWithErrorMessage:(NSString *)message;
```

### - Implement table views with very little code:
Forget about dealing with nib loading, cell reusing, etc. Just set the name of the nib file that corresponds to the cell that the table will use in the setUp method like this:

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

### - Add **pull-to-refresh** to you tables with one like of code:
Just set

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

### - Implement **infinite scrolling** in you table views:
Just set:
       
```Objective-c
self.tableHasInfiniteScrolling = YES;
```

And you will be called to this method:

```Objective-c
- (void)loadMoreItemsAfterTheLastOne;
```

### - Automatically have your view adjusted when the keyboard appears / disappears:
Just by calling

```Objective-c
[self registerForKeyboardNotifications];
```

in your setUp method. If it's a regular view controller, you can implement 

```Objective-c
- (void)viewWillAdjustForKeyboardHidden:(BOOL)keyboardHidden keyboardHeight:(CGFloat)keyboardHeight;
```

which will be called inside an animation block that goes along with the keyboard.
If it's a *Table View Controller*, the table will automatically adjust. if you want to provide custom behaviour, you can implement

```Objective-c
- (void)tableViewWillBeResizedToAdjustForKeyboardHidden:(BOOL)keyboardHidden keyboardHeight:(CGFloat)keyboardHeight;
```

which will be called inside the animation block.

### - Have a view stick on top of the keyboard and animate with it:
(very convenient for typical chat / comment views). Just implement the method:

```Objective-c
- (UIView *)keyboardAuxView;
```

and return the view that you want to stay on top of the keyboard.

### - Implement tables that show data from Core Data with very little code:
(and that are automatically refreshed with changes in them).
Inherit from [*JSBaseCoreDataTableViewController*](https://github.com/JaviSoto/Base-iOS-View-Controllers/blob/master/JSBaseCoreDataTableViewController.h) and implement:

```Objective-c
- (NSFetchRequest *)fetchRequest;
```

to return an *NSFetchRequest* object corresponding to the query you want to perform. And then implement this other method that will be called on you:

```Objective-c
- (UITableViewCell *)tableView:(UITableView *)tv configureCell:(UITableViewCell *)cell forManagedObject:(NSManagedObject *)object;
```

### - Have all your cells automatically be correctly reused even if you forget to set the reuse identifier in Interface Builder:
For this you only need to make your cell classes inherit from [*JSBaseTableViewCell*](https://github.com/JaviSoto/Base-iOS-View-Controllers/blob/master/JSBaseTableViewCell.h).

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

**Second**. Drag the BaseControllers folder to your Xcode project. And remove the unneeded files (like the EGOTableViewPullRefresh sample project)

**Third**. Link against these frameworks:

```
CoreData
QuartzCore
```

**Fourth**. (Optional) Modify the method - (NSManagedObjectContext *)managedObjectContext in [*JSBaseViewController*](https://github.com/JaviSoto/Base-iOS-View-Controllers/blob/master/JSBaseViewController.m) by adding the needed logic to create a NSManagedObjectContext passing your NSPersistantStoreCordinator (ONLY IF YOU WANT TO USE CORE DATA).

#Credits

Thanks to [Oriol Blanc](http://es.linkedin.com/in/oriolblanc), because a lot of this is thanks to him :)
