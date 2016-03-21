//
//  ViewController.h
//  CollectionViewinTableCell
//
//  Created by Preetam Jadakar on 20/02/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceCommunicator.h"
#import <CoreLocation/CoreLocation.h>
#import "BaseCell.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,CLLocationManagerDelegate>

@property (nonatomic)NSMutableArray* dataSource;
- (IBAction)addCity:(id)sender;
@property (nonatomic)CLLocationManager *locationManager;

@end

