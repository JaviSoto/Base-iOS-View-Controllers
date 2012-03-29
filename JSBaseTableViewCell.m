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

#import "JSBaseTableViewCell.h"

#import <QuartzCore/QuartzCore.h>

@implementation JSBaseTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier
{
    return [[self class] reuseIdentifier];
}

+ (NSUInteger)numberOfElementsPerRow
{
    return 1;
}

+ (CGFloat)cellHeight
{
    return kBaseTableViewCellNoCellHeightSet;
}

- (BOOL)shouldRasterizeCell
{
    return self.layer.shouldRasterize;
}

- (void)setShouldRasterizeCell:(BOOL)shouldRasterizeCell
{
    self.layer.shouldRasterize = shouldRasterizeCell;
    
    if (shouldRasterizeCell)
    {
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    }         
}

@end
