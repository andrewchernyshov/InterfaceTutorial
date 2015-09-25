//
//  CustomCell.h
//  InterfaceTutorial
//
//  Created by student on 9/23/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;

@end
