//
//  MainViewController.m
//  InterfaceTutorial
//
//  Created by student on 9/23/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "CustomCell.h"
#import "CreateViewController.h"
#import "MainViewController.h"
#import "TaskObject.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSMutableArray *arrayOfTasks;
@property (nonatomic, weak) IBOutlet UITableView *taskListTableView;

@end

@implementation MainViewController
static NSString *cellIdentifier = @"CustomCell";

#pragma mark - Initialization Section

- (SaveAndLoadManager *)saveAndLoadManager {
    
    if (!_saveAndLoadManager) {
        _saveAndLoadManager = [[SaveAndLoadManager alloc] init];
    }
    return _saveAndLoadManager;
}


- (NSMutableArray *)arrayOfTasks {
    
    if (!_arrayOfTasks) {
        _arrayOfTasks = [self.saveAndLoadManager fetchAllTasks];
    }
    return _arrayOfTasks;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.taskListTableView.estimatedRowHeight = 44.0f;
    self.taskListTableView.rowHeight = UITableViewAutomaticDimension;
    [self.taskListTableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];

    UIBarButtonItem *addTaskButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask:)];
    self.navigationItem.rightBarButtonItem = addTaskButton;
    self.navigationItem.title = @"Task list";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate Section

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell layoutIfNeeded];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskObject *chosenTask = [self.arrayOfTasks objectAtIndex:indexPath.row];
    chosenTask.currentIndex = indexPath.row;
    CreateViewController *editVC = [[CreateViewController alloc] initWithNibName:@"CreateViewController" bundle:[NSBundle mainBundle]];
    [editVC addSaveDeleteButtons];
    editVC.task = chosenTask;
    editVC.isEditing = YES;
    
    __weak typeof (self) weakSelf = self;
    
    editVC.deleteTaskBlock = ^(TaskObject *task) {
        [weakSelf.saveAndLoadManager deleteTask:task];
        [weakSelf.taskListTableView reloadData];
    };
    
    editVC.saveTaskBlock = ^(TaskObject *task) {
        [weakSelf.saveAndLoadManager saveTask:task];
        [weakSelf.taskListTableView reloadData];
        [weakSelf.saveAndLoadManager saveDataToSQlite];
    };

    editVC.saveEditedTaskBlock = ^(TaskObject *editedTask) {
        
        [weakSelf.saveAndLoadManager saveEditedTask:editedTask];
        [weakSelf.taskListTableView reloadData];
        [weakSelf.saveAndLoadManager saveDataToSQlite];

    };
    
    [self.navigationController pushViewController:editVC animated:YES];
    
}

#pragma mark - UITableView DataSource Section

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayOfTasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    TaskObject *currentTask = self.arrayOfTasks [indexPath.row];
    cell.taskLabel.text = currentTask.task;
    cell.dueDateLabel.text = currentTask.dueDate;

    return cell;

}

#pragma mark Target Action Section

- (void) addTask: (UIBarButtonItem *)sender {
    
    CreateViewController *createVC = [[CreateViewController alloc] initWithNibName:@"CreateViewController" bundle:[NSBundle mainBundle]];
    [createVC addSaveButton];
    
    __weak typeof (self) weakSelf = self;

    createVC.saveTaskBlock = ^(TaskObject *task) {
        [weakSelf.saveAndLoadManager saveTask:task];
        [weakSelf.taskListTableView reloadData];
    };
    
    
    [self.navigationController pushViewController:createVC animated:YES];
}
@end