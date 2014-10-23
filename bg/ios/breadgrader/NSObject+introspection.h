//
//  NSObject+introspection.h
//  breadgrader
//
//  Created by Brian Kim on 1/3/14.
//  Copyright (c) 2014 breadtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (introspection)

- (NSArray *)propertyKeys;
- (NSDictionary *)propertyDict;

@end
