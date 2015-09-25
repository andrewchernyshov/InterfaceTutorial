//
//  CreateViewController.h
//  InterfaceTutorial
//
//  Created by student on 9/24/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskObject.h"

@interface CreateViewController : UIViewController
@property (nonatomic, strong) TaskObject *task;
@property (nonatomic, copy) void (^saveEditedTaskBlock) (TaskObject *);
@property (nonatomic, copy) void (^saveTaskBlock)(TaskObject *);
@property (nonatomic, copy) void (^deleteTaskBlock)(TaskObject *);
@property (nonatomic, assign) BOOL isEditing;
- (void) addSaveButton;
- (void) addSaveDeleteButtons;

@end
