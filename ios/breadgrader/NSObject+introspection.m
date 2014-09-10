//
//  NSObject+introspection.m
//  breadgrader
//
//  Created by Brian Kim on 1/3/14.
//  Copyright (c) 2014 breadtech. All rights reserved.
//

#import "NSObject+introspection.h"
#import <objc/runtime.h>

@implementation NSObject (introspection)

- (NSArray *)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity: outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [retval addObject: propertyName];
    }
    return retval;
}

- (NSDictionary *)propertyDict
{
    NSArray *keys = [self propertyKeys];
    NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithCapacity: [keys count]];
    for (NSString *key in keys)
    {
        [retval setObject: [self valueForKey: key] forKey: key];
    }
    return retval;
}

@end
