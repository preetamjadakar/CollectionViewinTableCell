//
//  BaseCell.m
//  CollectionViewinTableCell
//
//  Created by Preetam Jadakar on 19/03/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (void)awakeFromNib {
    // Initialization code
    //collectionview set up
    self.weatheCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.weatheCollectionView registerNib:[UINib nibWithNibName:@"ForecastDataCell" bundle:nil] forCellWithReuseIdentifier:kForecastCellID];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.sectionInset = UIEdgeInsetsMake(0, PADDING*2, 0,PADDING*2);
    layout.minimumInteritemSpacing = PADDING*2;
    [self.weatheCollectionView setCollectionViewLayout:layout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.forecastDataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ForecastDataCell *cell =
    (ForecastDataCell *)[self.weatheCollectionView dequeueReusableCellWithReuseIdentifier:kForecastCellID
                                                                             forIndexPath:indexPath];
    
    
    Weather *weather = [self.forecastDataArray objectAtIndex:indexPath.row];
    
    cell.dayLabel.text = weather.forecastDate;
    cell.weatherStatus.text = weather.weatherStatus;
    cell.minTemp.text = [NSString stringWithFormat:@"%d%@",weather.minTemp, kDegreeUC];
    cell.maxTemp.text = [NSString stringWithFormat:@"%d%@",weather.maxTemp, kDegreeUC];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(138, 138);
}
@end
