//
//  CustomCell.m
//  InterfaceTutorial
//
//  Created by student on 9/23/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {

    //self.taskLabel.numberOfLines = 0;
    self.taskLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.dueDateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
