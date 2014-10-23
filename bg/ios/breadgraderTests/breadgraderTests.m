//
//  breadgraderTests.m
//  breadgraderTests
//
//  Created by Brian Kim on 8/6/13.
//  Copyright (c) 2013 breadtech. All rights reserved.
//

#import "breadgraderTests.h"
#import "BGGradeInfo.h"

@implementation breadgraderTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    for (int i = 0; i < 100000; i++)
    {
        double received = arc4random() % 100;
        double max = 100;
        BGGradeInfo *gr = [[BGGradeInfo alloc] initWithGrade: received outOf: max];
        STAssertEquals( gr.floatValue, received/max, @"gradeinfo floatvalue v straight division");
    }
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in breadgraderTests");
}

@end
