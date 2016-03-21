//
//  ForecastDataCell.h
//  CollectionViewinTableCell
//
//  Created by Preetam Jadakar on 19/03/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastDataCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;

@property (strong, nonatomic) IBOutlet UILabel *weatherStatus;
@property (strong, nonatomic) IBOutlet UILabel *minTemp;
@property (strong, nonatomic) IBOutlet UILabel *maxTemp;
@end
