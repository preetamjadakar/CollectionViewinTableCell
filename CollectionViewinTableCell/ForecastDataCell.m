//
//  ForecastDataCell.m
//  CollectionViewinTableCell
//
//  Created by Preetam Jadakar on 19/03/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//

#import "ForecastDataCell.h"

@implementation ForecastDataCell

- (void)awakeFromNib {
    // Initialization code
    //adds some shadow effect
    self.layer.shadowColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 1.0f;
    self.layer.shadowOpacity = 1.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
}

@end
