//
//  JSChatCell.h
//  BaseiOSViewControllers-DemoProject
//
//  Created by Javier Soto on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSBaseTableViewCell.h"

@interface JSChatCell : JSBaseTableViewCell

+ (CGFloat)heightOfChatCellWithMessage:(NSString *)message;

- (void)setChatMessage:(NSString *)chatMessage;

@end
