//
//  SaveAndLoadManager.m
//  InterfaceTutorial
//
//  Created by student on 9/24/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "SaveAndLoadManager.h"
#import "TaskObject.h"

@interface SaveAndLoadManager ()

@property (nonatomic, strong) NSMutableArray *arrayOfTasks;
@property (nonatomic, copy) NSString *documentDirectory;
@property (nonatomic, copy) NSString *dbPath;

@end

@implementation SaveAndLoadManager

- (NSMutableArray *)arrayOfTasks {

    if (!_arrayOfTasks) {
        _arrayOfTasks = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 20.0f; i++) {
            TaskObject *task = [[TaskObject alloc] init];
            task.task = [NSString stringWithFormat:@"This is the haviest task for today. Its ID is #%d", i];
            task.dueDate = @"Monday";
            [_arrayOfTasks addObject:task];
        }
        
    }
    
    return _arrayOfTasks;
}

- (NSString *)documentDirectory {
    
    if (!_documentDirectory) {
        _documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    return _documentDirectory;
}

- (NSString *) dbPath {
    
    if (!_dbPath) {
        _dbPath = [self.documentDirectory stringByAppendingPathComponent:@"taskListDB"];
    }
    return _dbPath;
    
}


- (BOOL) dataBaseCheck{
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:self.dbPath]) {
        const char *dbPath = [self.dbPath UTF8String];
        
        if (sqlite3_open(dbPath, &_db) == SQLITE_OK) {
            char *errorMessage;
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS tasks (id INTEGER SERIAL, task TEXT, dueDate TEXT, currentIndex INTEGER)";
            if (sqlite3_exec(self.db, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                
                NSLog(@"Save and load manager failed to create data base.");
                
            }
            sqlite3_close(self.db);
        }
        
        NSLog(@"Save and load manager failed to open / create data base.");
        
    }
    
    
    
    return YES;
}

- (NSMutableArray *)fetchAllTasks {
    
    return self.arrayOfTasks;
    
}

- (void)saveTask:(TaskObject *)task {
    
    [self.arrayOfTasks insertObject:task atIndex:0];
    
}

- (void)deleteTask:(TaskObject *)task {
    
    [self.arrayOfTasks removeObjectAtIndex:task.currentIndex];
    
}

- (void)saveEditedTask: (TaskObject *)editedTask {
    
    [self.arrayOfTasks replaceObjectAtIndex:editedTask.currentIndex withObject:editedTask];
}

- (void) selectDataFromSQlite {
    
    sqlite3_stmt *statement;
    const char *dbPath = [self.dbPath UTF8String];
    
    if (sqlite3_open(dbPath, &_db) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM tasks"];
        const char*query_statement = [querySQL UTF8String];
        if (sqlite3_prepare_v2(self.db, query_statement, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *task = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *dueDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSLog(@"%@, %@", task, dueDate);
            }
        }
    }
    
}

- (void) saveDataToSQlite {
    [self dataBaseCheck];
    sqlite3_stmt *statement;
    const char *dbPath = [self.dbPath UTF8String];
    TaskObject *task = [TaskObject new];
    task.task = @"Current task";
    task.dueDate = @"Monday";
    if (sqlite3_open(dbPath, &_db) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO tasks (task, dueDate, currentIndex) VALUES (\"%@\", \"%@\", \"%lu\")", task.task , task.dueDate, (unsigned long)task.currentIndex];
        const char *insert_statement = [insertSQL UTF8String];
        sqlite3_prepare_v2(self.db, insert_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Task is added to database");
        } else {
            
            NSLog(@"Save and load manager failed to save a task in data base");
            sqlite3_close(self.db);
        }
    }
    
}

@end
