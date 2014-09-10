//
//  BGMenuController.h
//  breadgrader
//
//  Created by Brian Kim on 12/20/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGMenuController : NSObject

// must change id to BGModel type
-(instancetype)initWithModel:(id)model
            andViewConroller:(UIViewController *)vc;

@end
