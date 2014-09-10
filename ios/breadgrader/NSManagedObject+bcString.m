//
//  NSManagedObject+bcString.m
//  breadgrader
//
//  Created by Brian Kim on 7/11/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "NSManagedObject+bcString.h"
#import "NSMutableString+appendIndent.h"

@implementation NSManagedObject (bcString)

- (NSString *)bcString
{
    return [self bcStringWithIndex: 1];
}

- (NSString *)bcStringWithIndex:(int)i
{
    return [self bcStringWithIndex: i indentationLevel: 0];
}

- (NSString *)bcStringWithIndex:(int)i
               indentationLevel:(int)indent
{
    NSEntityDescription *ed = self.entity;
    
    NSMutableString *ret = [@"" mutableCopy];
    [ret appendIndent: indent];
    [ret appendFormat: @"$<%@> %@%i\n", ed.name, ed.name.lowercaseString, i];
    
    for (NSString *a in ed.attributesByName.allKeys) {
        id value = [self valueForKey:a];
        
        if (value) {
            if ([value isKindOfClass:[NSString class]]) {
                [ret appendIndent: indent];
                [ret appendFormat:@"\t%@=\"%@\"\n", a, value];
            } else if ([value isKindOfClass: [NSDate class]])
            {
                [ret appendIndent: indent];
                [ret appendFormat: @"\t%@=%f\n", a, [value timeIntervalSince1970]];
            } else {
                [ret appendIndent: indent];
                [ret appendFormat:@"\t%@=%@\n", a, [value description]];
            }
        }
    }
    
    bool hasChildren = NO;
    
    for (NSString *r in ed.relationshipsByName) {
        if (!hasChildren) {
            hasChildren = YES;
        }
        
        NSRelationshipDescription *rd = [ed.relationshipsByName objectForKey:r];
        
        if (rd.isToMany) {
            hasChildren = YES;
            [ret appendIndent: indent];
            [ret appendFormat:@"\t%@:\n", r];
            
            int j = 1;
            for (NSManagedObject *obj in [self valueForKey: r])
            {
                [ret appendFormat: @"%@", [obj bcStringWithIndex: j indentationLevel: indent+2]];
                j++;
            }
        }
    }
    return ret;
}

/*
- (id)initWithBcString:(NSString *)bcString inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSString *type, *identifier;
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName: type inManagedObjectContext: moc];
    
    [moc save: nil];
    return obj;
}
 */

@end
