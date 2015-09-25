//
//  CreateViewController.m
//  InterfaceTutorial
//
//  Created by student on 9/24/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *dueDateField;
@property (nonatomic, weak) IBOutlet UITextView *taskView;

@end

@implementation CreateViewController

#pragma mark - Initialization Section

- (TaskObject *)task {
    
    if (!_task) {
        _task = [[TaskObject alloc] init];
    }
    return _task;
}

#pragma mark - Actions Section

- (void) saveTask: (UIBarButtonItem *)sender {
    
    TaskObject *newTask = [[TaskObject alloc] init];
    newTask.task = self.taskView.text;
    newTask.dueDate = self.dueDateField.text;
    newTask.currentIndex = self.task.currentIndex;
    
    if (!self.isEditing) {
        self.saveTaskBlock (newTask);
    } else {
        self.saveEditedTaskBlock (newTask);
    }
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) deleteTask: (UIBarButtonItem *) sender {
    
    
    self.deleteTaskBlock (self.task);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Navigation Item Configuration Section

- (void) addSaveButton {
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTask:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void) addSaveDeleteButtons {
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteTask:)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTask:)];
    NSArray *navBarButtons = [NSArray arrayWithObjects:deleteButton, saveButton, nil];
    self.navigationItem.rightBarButtonItems = navBarButtons;

}

#pragma mark - TextField Delegate Section

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.dueDateField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dueDateField setInputView:datePicker];
    return YES;
}

- (void)updateTextField: (UIDatePicker *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE, MMM d, ''yyyy";
    self.dueDateField.text = [formatter stringFromDate:sender.date];
}


#pragma mark - TextView Delegate Section

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.view setFrame: CGRectMake(0.0f, -70.0f, self.view.bounds.size.width, self.view.bounds.size.height)];
        
    }];
    
    if (!self.isEditing) {
        self.taskView.text = nil;
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.view setFrame: CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height)];
        
    }];
    return YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    
    return YES;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.taskView.text isEqualToString: @""]) {
        self.taskView.text = @"Specify your task here...";
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.task.task) {
        self.taskView.text = self.task.task;
        self.dueDateField.text = self.task.dueDate;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end