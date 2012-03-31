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

#import <UIKit/UIKit.h>

#define kBaseTableViewCellNoCellHeightSet 0.0f

@interface JSBaseTableViewCell : UITableViewCell

/* Convenient property to rasterize the cell with fewer lines of code */
@property (nonatomic, assign) BOOL shouldRasterizeCell;

/* Convenient method to get the reuseIdentifier from the class itself without instantiating it */
+ (NSString *)reuseIdentifier;

/* Useful to make calculations from the controller when you have grid-like cells */
+ (NSUInteger)numberOfElementsPerRow;

/* Implement if you want to have all JSBaseTableViewControllers to set the table view row height to whatever you return, instead of having to each it on the .xib file */
+ (CGFloat)cellHeight;

@end