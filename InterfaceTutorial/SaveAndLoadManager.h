//
//  SaveAndLoadManager.h
//  InterfaceTutorial
//
//  Created by student on 9/24/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskObject.h"
#import <sqlite3.h>

@interface SaveAndLoadManager : NSObject

@property (nonatomic, copy) NSString *databasePath;
@property (nonatomic) sqlite3 *db;

- (void) deleteTask: (TaskObject *)task;

- (NSMutableArray *)fetchAllTasks;

- (void) selectDataFromSQlite;

- (void) saveDataToSQlite;

- (void)saveEditedTask: (TaskObject *)editedTask;

- (void) saveTask:(TaskObject *)task;

@end