//
//  BaseCell.h
//  CollectionViewinTableCell
//
//  Created by Preetam Jadakar on 19/03/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ForecastDataCell.h"
#import "Weather.h"

@interface BaseCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *weatheCollectionView;

@property(nonatomic)NSArray *forecastDataArray;//used to display forecast data
@end
