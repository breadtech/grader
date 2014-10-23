//
//  BMModel.m
//  breadgrader
//
//  Created by Brian Kim on 1/3/14.
//  Copyright (c) 2014 breadtech. All rights reserved.
//

#import "BMModel.h"
#import "NSObject+introspection.h"

typedef enum
{
    BMModelTypeNSObject,
    BMModelTypeNSManagedObject,
    BMModelTypeJSON,
    BMModelTypeBC
} BMModelType;

@interface BMModel()
{
    BMModelType modelType;
}
@property (nonatomic, strong) Class modelClass;
@property (nonatomic, strong) NSObject *obj;
@property (nonatomic, strong) NSManagedObject *managedObj;
@property (nonatomic, strong) NSData *jsonData;
@property (nonatomic, strong) NSString *bcString;
@end

@implementation BMModel

- (instancetype)initWithNSObject:(NSManagedObject *)obj
{
    self = [super init];
    if (self)
    {
        self.obj = obj;
        modelType = BMModelTypeNSObject;
        self.modelClass = [obj class];
    }
    return self;
}

- (instancetype)initWithManagedObject:(NSManagedObject *)managedObj
{
    self = [super init];
    if (self)
    {
        self.managedObj = managedObj;
        modelType = BMModelTypeNSManagedObject;
        self.modelClass = [managedObj class];
    }
    return self;
}

- (instancetype)initWithJSONData:(NSData *)jsonData
{
    self = [super init];
    if (self)
    {
        if ([NSJSONSerialization isValidJSONObject: jsonData])
        {
            self.jsonData = jsonData;
        }
        else
        {
            [NSException raise: @"Invalid JSON Data" format: @"%@ is not a valid json object", jsonData];
        }
        modelType = BMModelTypeJSON;
        self.modelClass = [self.obj class];
    }
    return self;
}

/** not yet implemented
 - (instancetype)initWithBcString:(NSString *)bcString;
 **/

- (Class)modelClass
{
    Class retval;
    switch (modelType)
    {
        case BMModelTypeBC:
            break;
        case BMModelTypeJSON:
            break;
        case BMModelTypeNSManagedObject:
            break;
        case BMModelTypeNSObject:
            break;
    }
    return retval;
}

- (NSObject *)obj
{
    if (!_obj)
    {
        switch (modelType)
        {
            case BMModelTypeNSObject:
            {
                // should never get here
                break;
            }
            case BMModelTypeNSManagedObject:
            {
                _obj = self.managedObj;
                break;
            }
            case BMModelTypeJSON:
            {
                NSError *err;
                _obj = [NSJSONSerialization JSONObjectWithData: self.jsonData options: NSJSONReadingAllowFragments error: &err];
                break;
            }
            case BMModelTypeBC:
            {
                // not yet implemented
                break;
            }
            default:
            {
                // should not get here
                _obj = nil;
                break;
            }
        }
    }
    return _obj;
}

- (NSManagedObject *)managedObjWithEntityName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSManagedObject *retval;
    switch (modelType)
    {
        case BMModelTypeNSObject:
        {
            retval = [NSEntityDescription insertNewObjectForEntityForName: name inManagedObjectContext: moc];
            
            NSArray *keys = [self.obj propertyKeys];
            for (NSString *key in keys)
            {
                [retval setValue: [self.obj valueForKey: key] forKey: key];
            }
            break;
        }
        case BMModelTypeNSManagedObject:
        {
            // should not get here
            break;
        }
        case BMModelTypeJSON:
        {
            retval = [NSEntityDescription insertNewObjectForEntityForName: name inManagedObjectContext: moc];
            
            NSError *err;
            NSObject *obj = [NSJSONSerialization JSONObjectWithData: self.jsonData
                                                            options: NSJSONReadingAllowFragments
                                                              error: &err];
            if ([obj isKindOfClass: [NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary *)obj;
                for (NSString *key in dict)
                {
                    [retval setValue: dict[key] forKey: key];
                }
            }
            else
            {
                retval = nil;
            }
            break;
        }
        case BMModelTypeBC:
        {
            // not yet implemented
            break;
        }
        default:
        {
            // should not get here
            retval = nil;
            break;
        }
    }
    return retval;
}

- (NSData *)jsonData
{
    if (!_jsonData)
    {
        switch (modelType)
        {
            case BMModelTypeNSObject:
            {
                NSError *err;
                NSMutableDictionary *dict = [[self.obj propertyDict] mutableCopy];
                [dict setValue: self.obj.class forKey: @"class"];
                _jsonData = [NSJSONSerialization dataWithJSONObject: dict options: 0 error: &err];
                break;
            }
            case BMModelTypeNSManagedObject:
            {
                NSError *err;
                NSDictionary *dict = self.managedObj.entity.propertiesByName;
                [dict setValue: self.managedObj.class forKey: @"class"];
                _jsonData = [NSJSONSerialization dataWithJSONObject: dict options: 0 error: &err];
                break;
            }
            case BMModelTypeJSON:
            {
                // should not get here
                break;
            }
            case BMModelTypeBC:
            {
                // not yet implemented
                break;
            }
            default:
            {
                // should not get here
            }
        }
    }
    return _jsonData;
    
}

@end
