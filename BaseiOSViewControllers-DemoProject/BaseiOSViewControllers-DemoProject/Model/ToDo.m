//
//  ToDo.m
//  BaseiOSViewControllers-DemoProject
//
//  Created by Javier Soto on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToDo.h"


@implementation ToDo

@dynamic title;
@dynamic desc;
@dynamic date;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.date = [NSDate date];
}

@end
