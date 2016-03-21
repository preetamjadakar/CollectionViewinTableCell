//
//  ViewController.m
//  CollectionViewinTableCell
//
//  Created by Preetam Jadakar on 20/02/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "WebServiceCommunicator.h"
#import "MBProgressHUD.h"


@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITableView *weaherTableView;

@property (strong, nonatomic)MBProgressHUD *activityIndicatorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicatorView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:self.activityIndicatorView];
    self.activityIndicatorView.opacity = 0.5;
    
    self.weaherTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.weaherTableView.backgroundColor = [UIColor clearColor];

    self.dataSource = [NSMutableArray new];

    //fetch users current location
    [self locationManagerConfiguration];
    
    
//    [self fetchData:@"pune"];
}
-(void)locationManagerConfiguration
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // location manager config for iOS 8 or later.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Location Manager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [manager location];
    if (location)
    {
        //if valid location found
        [manager stopUpdatingLocation];
        self.locationManager = nil;//some time it wont stop updating location so forcefully deallocated
        
        [self.activityIndicatorView setLabelText:@"fetching current weather..."];
        
        //can use cityname(using reverse geocoding) but lat long is used for the more accurate location specific result
        //fortunately lat-long specific API is available
        [self fetchData:location];
        
        
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    if ([error domain] == kCLErrorDomain) {
        
        // We handle CoreLocation-related errors here
        switch ([error code]) {
                
            case kCLErrorDenied:
                //access denied when user asked by iOS
            {
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Error" message:@"Looks like you denied location access. Please go to settings and turn on access." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings",nil];
                errorAlert.tag = 101;
                [errorAlert show];
            }
                break;
            case kCLErrorLocationUnknown:
                //...
            {
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Error" message:@"Failed to get your location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [errorAlert show];
            }
                break;
            default:
                //...
                break;
        }
    } else {
        // We handle all non-CoreLocation errors here
    }
}

# pragma mark - UITableViewControllerDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kBaseCellID];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BaseCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    City *city = [self.dataSource objectAtIndex:indexPath.row];
    cell.forecastDataArray=city.forecastArray;
    [cell.weatheCollectionView reloadData];
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 148;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    City *city = [self.dataSource objectAtIndex:section];
    return city.cityName;
}
//if reuired to make section header transperent
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
//        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
//        headerView.contentView.backgroundColor = [UIColor clearColor];
//        headerView.backgroundView.backgroundColor = [UIColor clearColor];
//    }
//}
#pragma mark - UIAlertViewDataDelegates
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag==101) {
        return YES;
    }
    UITextField *textInput = [alertView textFieldAtIndex:0];
    if (textInput.text.length>1) {
        return YES;
    }
    return NO;
}

#pragma mark Take City name input
- (IBAction)addCity:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Please enter City name."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 100;
    [alert show];
    
}

#pragma mark UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==101) {
        if (buttonIndex==1) {
            
            //done
            if(IS_OS_8_OR_LATER)
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            else
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }
        else
        {
            //cancel
        }
    }
    else   if (alertView.tag==100) {
        if (buttonIndex==1) {
            //done
            [self.activityIndicatorView setLabelText:nil];
            
            UITextField *textInput = [alertView textFieldAtIndex:0];
            [self fetchData:textInput.text];
        }
        else
        {
            //cancel
        }
    }
}
#pragma mark WeatherCell Delegate


#pragma mark WebserviceCommunicator Delegate Response
//just to avaid code redundency, made it reusable
-(void)fetchData:(id)cityNameOrCLLocation
{
    if ([[WebServiceCommunicator sharedInstance]isNetworkConnection]) {
        [self.activityIndicatorView show:YES];
        
        [[WebServiceCommunicator sharedInstance]fetchForcastDataForCity:cityNameOrCLLocation andCompletionHandler:^(City *cityObject, NSError *error) {
            
            if (error == nil) {
                
                [self.dataSource addObject:cityObject];
                [self.weaherTableView reloadData];
                
                
                [self.activityIndicatorView hide:YES];
                
            }
            else
            {
                [self.activityIndicatorView hide:YES];
                
                [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
                
            }
            
        }];
    }
    else
    {
        [[[UIAlertView alloc]
          initWithTitle:@"Error" message:kNetworkErrorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    
}
@end
