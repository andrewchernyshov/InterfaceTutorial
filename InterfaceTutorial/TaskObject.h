//
//  TaskObject.h
//  InterfaceTutorial
//
//  Created by student on 9/24/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskObject : NSObject

@property (nonatomic, copy) NSString *task;
@property (nonatomic, copy) NSString *dueDate;
@property (nonatomic, assign) NSUInteger currentIndex;

@end
