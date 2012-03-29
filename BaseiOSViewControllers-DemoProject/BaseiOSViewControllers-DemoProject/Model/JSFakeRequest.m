//
//  JSFakeRequest.m
//  BaseiOSViewControllers-DemoProject
//
//  Created by Javier Soto on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSFakeRequest.h"

@implementation JSFakeRequest

+ (void)makeFakeRequestWithCallback:(JSFakeRequestCallback)callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger randomRequestLength = (arc4random() & 4) + 1;
        
        sleep(randomRequestLength);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            BOOL success = (arc4random() % 5);
            
            callback(success);
        });
    });
}

@end
