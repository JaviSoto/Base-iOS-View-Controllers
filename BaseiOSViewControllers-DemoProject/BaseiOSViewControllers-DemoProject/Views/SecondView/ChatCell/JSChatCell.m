//
//  JSChatCell.m
//  BaseiOSViewControllers-DemoProject
//
//  Created by Javier Soto on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSChatCell.h"

@interface JSChatCell()
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@end

@implementation JSChatCell

@synthesize messageLabel = _messageLabel;

static UIFont *_messageFont;

+ (void)initialize
{
    _messageFont = [[UIFont systemFontOfSize:17.0] retain];
}

+ (CGFloat)heightOfChatCellWithMessage:(NSString *)message
{
    static const CGFloat kCellMinHeight = 48.0f;
    static const CGFloat kCellLabelHeightOffset = 22.0f;
    static const CGFloat kMessageLabelWidth = 294.0;
    
    CGFloat suggestedHeight = rint([message sizeWithFont:_messageFont constrainedToSize:CGSizeMake(kMessageLabelWidth, MAXFLOAT)].height + kCellLabelHeightOffset);
    
    return MAX(kCellMinHeight, suggestedHeight);
}

- (void)setChatMessage:(NSString *)chatMessage
{
    self.messageLabel.text = chatMessage;
}

#pragma mark - Memory Management

- (void)dealloc
{
    [_messageLabel release];
    
    [super dealloc];
}

@end
