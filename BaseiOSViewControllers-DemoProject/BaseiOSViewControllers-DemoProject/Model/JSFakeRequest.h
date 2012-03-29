//
//  JSFakeRequest.h
//  BaseiOSViewControllers-DemoProject
//
//  Created by Javier Soto on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JSFakeRequestCallback) (BOOL success);

@interface JSFakeRequest : NSObject

+ (void)makeFakeRequestWithCallback:(JSFakeRequestCallback)callback;

@end
