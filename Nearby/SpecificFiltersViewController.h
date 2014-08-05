//
//  SpecificFiltersViewController.h
//  NearbyApp
//
//  Created by Jayant Madugula on 12/27/13.
//  Copyright (c) 2013 iD Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>
#import "NearbyLocationObjects.h"
#import "LocationsViewController.h"

@interface SpecificFiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UITextFieldDelegate>
{
    NSInteger selectedRow;
    BOOL addFilter;
    
    CLLocation* currentLocation;
    IBOutlet ADBannerView *bottomAd;
}

#pragma mark Properties – Subviews
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *addFilterView;
@property (strong, nonatomic) IBOutlet UILabel *addFilterLabel;
@property (strong, nonatomic) IBOutlet UITextField *filterTextField;
@property IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchButton;


#pragma mark Properties – Variables
@property NSMutableArray *dataArray;
@property NSMutableArray *searchList;


#pragma mark Methods – Dealing with Views
- (void)setUpData;
- (IBAction)callEditingMethod:(id)sender;
- (IBAction)openAddFilterView:(id)sender;
- (void)openEditFilterView: (NSString *)currentFilterName;
- (IBAction)closeAddFilterView:(id)sender;
- (void)setSearchButtonTitle;


#pragma mark Methods – Dealing with Data
- (void)presentData: (NSString *)request andCurrentLocation:(CLLocation *)location;
- (IBAction)searchButtonTapped:(id)sender;
- (void)uploadUserDefaults;
@end
