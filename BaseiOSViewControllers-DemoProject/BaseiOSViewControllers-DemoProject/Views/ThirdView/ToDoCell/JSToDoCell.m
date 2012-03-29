//
//  JSToDoCell.m
//  BaseiOSViewControllers-DemoProject
//
//  Created by Javier Soto on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSToDoCell.h"

#import "ToDo.h"

@interface JSToDoCell()
@property (retain, nonatomic) IBOutlet UILabel *toDoTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation JSToDoCell
@synthesize toDoTitleLabel;
@synthesize dateLabel;

+ (CGFloat)cellHeight
{
    return 61.0f;
}

- (void)setToDo:(ToDo *)toDo
{
    self.toDoTitleLabel.text = toDo.title;
    self.dateLabel.text = [toDo.date descriptionWithLocale:[NSLocale currentLocale]];
}

#pragma mark - Memory Management

- (void)dealloc
{
    [toDoTitleLabel release];
    
    [dateLabel release];
    [super dealloc];
}
@end
