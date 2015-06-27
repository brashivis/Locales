//
//  SpecificFiltersViewController.m
//  NearbyApp
//
//  Created by Jayant Madugula on 12/27/13.
//  Copyright (c) 2013 iD Student. All rights reserved.
//

#import "SpecificFiltersViewController.h"
#import <iAd/iAd.h>

@interface SpecificFiltersViewController ()

@end

@implementation SpecificFiltersViewController

@synthesize dataArray, tableView, navigationBar, searchList, addFilterView, filterTextField, searchButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.canDisplayBannerAds = YES;
    
    //Set up UI (View and Sub-Views)
    [self.view addSubview:self.addFilterView];
    [self.view sendSubviewToBack:self.addFilterView];
    
    self.filterTextField.alpha = 1.0;
    self.filterTextField.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"HelveticaNeue-Thin" size:24],
      NSFontAttributeName, nil]];
    
    NSLog(@"SetUpData being called from ViewDidLoad –– SpecificFiltersVC.m");

    [self setUpData];
    [self setSearchButtonTitle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)setSearchButtonTitle
{
    long num = [self.searchList count];
    
    if (num != 1)
    {
        NSString* searchButtonTitle = [NSString stringWithFormat:@"Search (%ld Filters Selected)", num];
        NSLog(@"%@", searchButtonTitle);
        self.searchButton.title = searchButtonTitle;
        
    }
    else
    {
        NSString* searchButtonTitle = [NSString stringWithFormat:@"Search (%ld Filter Selected)", num];
        NSLog(@"%@", searchButtonTitle);
        self.searchButton.title = searchButtonTitle;
    }
    
}

- (IBAction)closeView:(id)sender //Closes SpecificFiltersVC
{   
    NSLog(@"Closing SearchList: %@", self.searchList);
    NSLog(@"Closing DataArray: %@", self.dataArray);
    
    [self uploadUserDefaults];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Data Methods

- (void)setUpData //Sets up default lists (Data Dictionary and White Dictionary)
{
    NSArray* arrayOfKeys = [[NSArray alloc] initWithObjects:@"Food and Drink", @"Entertainment", @"Local Attractions", @"Shopping", @"Lodging", @"Transportation", @"Healthcare", @"Favorites", nil];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Data Dictionary"]) //Checks if dataDictionary already exists.
    {
        NSMutableArray* restaurantArray = [[NSMutableArray alloc] initWithObjects:@"Restaurant", @"Pizza", @"Bar", @"Fast Food", @"Breakfast", @"Café", @"Vegan", nil];
        NSMutableArray* entertainmentArray = [[NSMutableArray alloc] initWithObjects:@"Movie Theater", @"Theater", @"Stadium", @"Museum", @"Art Gallery", @"Park", @"Concert Hall", nil];
        NSMutableArray* attractionsArray = [[NSMutableArray alloc] initWithObjects:@"Theme Park", @"Water Park", @"Landmark", nil];
        NSMutableArray* shoppingArray = [[NSMutableArray alloc] initWithObjects:@"Mall", @"Supermarket", @"Grocery Store", nil];
        NSMutableArray* lodgingArray = [[NSMutableArray alloc] initWithObjects:@"Hotels", @"Motels", @"Bed & Breakfast", @"Resorts", nil];
        NSMutableArray* transportationArray = [[NSMutableArray alloc] initWithObjects:@"Train Station", @"Airport", @"Subway Station", @"Bus Stop", @"Taxi Stand", @"Gas Station", nil];
        NSMutableArray* healthcareArray = [[NSMutableArray alloc] initWithObjects:@"Hospital", @"Clinic", @"Doctors", @"Dentists", @"Pharmacy", @"Rehab", nil];
        NSMutableArray* favoritesArray = [[NSMutableArray alloc] initWithObjects:@"Gas Station", @"Grocery Store", @"Movie Theater", nil];
    
        NSArray* arrayofTopicArrays = [[NSArray alloc] initWithObjects:restaurantArray, entertainmentArray, attractionsArray, shoppingArray, lodgingArray, transportationArray, healthcareArray, favoritesArray, nil];
        
    
        NSMutableDictionary* dataDictionary = [[NSMutableDictionary alloc] initWithObjects:arrayofTopicArrays forKeys:arrayOfKeys];
        
        [[NSUserDefaults standardUserDefaults] setObject:dataDictionary forKey:@"Data Dictionary"]; //Sets defaults.
        NSLog(@"Setup: %@", [dataDictionary objectForKey:@"Local Attractions"]);
    }
    
    else
    {
        NSLog(@"DataDictionary is already populated. –– setUpData, SpecificFiltersVC.m");
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Search Dictionary"])
    {
        NSMutableDictionary* searchDictionary = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < 7; i++)
        {
            NSArray* array = [[NSArray alloc] init];
            [searchDictionary setObject:array forKey:arrayOfKeys[i]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:searchDictionary forKey:@"Search Dictionary"];
    }
    
    else
    {
        NSLog(@"SearchDictionary is already populated");
    }
}

- (void)presentData:(NSString *)request //called by SettingsViewController, loads correct data into tableView.
{
    self.navigationBar.topItem.title = request;
    
    [self setUpData];
    
    NSDictionary* searchDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"Search Dictionary"];
    self.searchList = [[searchDictionary objectForKey:request] mutableCopy];
    [self setSearchButtonTitle];
    if (!self.searchList) { self.searchList = [[NSMutableArray alloc] init]; }
    NSLog(@"First SearchList: %@", self.searchList);
    
    NSDictionary* dataDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"Data Dictionary"];
    self.dataArray = [[dataDictionary objectForKey:request] mutableCopy]; //Gets relevant dataArray.
    NSLog(@"request: %@, First DataArray: %@", request, self.dataArray);
    
    [self.tableView reloadData]; //Uses dataArray to present loaded data.
}

- (void)uploadUserDefaults
{
    if (self.searchList)
    {
        NSLog(@"SearchList updated: %@", self.searchList);
        NSMutableDictionary* searchDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Search Dictionary"] mutableCopy];
        [searchDict setObject:self.searchList forKey:self.navigationBar.topItem.title];
        [[NSUserDefaults standardUserDefaults] setObject:searchDict forKey:@"Search Dictionary"];
    }
    else { NSLog(@"SearchList not updated in UserDefaults"); }
    
    if (self.dataArray)
    {
        NSLog(@"DataArray updated: %@", self.dataArray);
        NSMutableDictionary* dataDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Data Dictionary"] mutableCopy];
        [dataDict setObject:self.dataArray forKey:self.navigationBar.topItem.title];
        [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"Data Dictionary"];
    }
    else { NSLog(@"DataArray not updated in UserDefaults"); }
}


#pragma mark Add/EditFilterView Methods
//Some of these methods are not active.

- (IBAction)openAddFilterView:(id)sender
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.addFilterView.center = CGPointMake(screenSize.width/2, screenSize.height - 350);
    [self.view bringSubviewToFront:self.addFilterView];
    self.addFilterView.alpha = 0.7;
    self.addFilterLabel.text = @"New Filter Name:";
    self.filterTextField.text = @"";
    addFilter = YES;
    
    [self.filterTextField becomeFirstResponder];
}

- (void)openEditFilterView:(NSString *)currentFilterName
{
    [self.view bringSubviewToFront:self.addFilterView];
    self.addFilterLabel.text = @"Edit Filter Name:";
    self.filterTextField.text = currentFilterName;
    addFilter = NO;
    
    [self.filterTextField becomeFirstResponder];
}

- (IBAction)closeAddFilterView:(id)sender
{
    [self.view sendSubviewToBack:self.addFilterView];
    self.addFilterView.alpha = 0.0;
    NSString* enteredText = self.filterTextField.text;
    if (addFilter == YES && [enteredText length] > 0) //Filter is being added and title is larger than 0 characters long.
    {
        NSLog(@"Title of new filter: %@ –– closeAddFilterView, SpecificFiltersVC.m", enteredText);
        [self.dataArray addObject:enteredText];
        [self.searchList addObject:enteredText];
        [self setSearchButtonTitle];
    }
    
    else if (addFilter == NO) //Existing filter is being edited: Shouldn't be called with current design.
    {
        [self.dataArray replaceObjectAtIndex:selectedRow withObject:enteredText]; //Replaces old entry with new filter name in dataArray.
        if ([self.searchList containsObject:enteredText] == YES) //If selected, replaces old entry with new filter name in whiteList.
        {
            [self.searchList replaceObjectAtIndex:selectedRow withObject:enteredText];
        }
    }
    
    [self.filterTextField resignFirstResponder];
    [self uploadUserDefaults];
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField //If user presses 'Return' on keyboard, program enters this method.
{
    [self closeAddFilterView:nil];
    return YES;
}

- (void)callEditingMethod:(id)sender
{
    [self.tableView setEditing:YES animated:YES];
}

- (IBAction)searchButtonTapped:(id)sender
{
    [self uploadUserDefaults];
    if ([self.searchList count] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Filters Selected!" message:@"Tap on one of the filters to select it. Tap again to turn it off." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [UIApplication sharedApplication].statusBarHidden = NO;
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Search Button Tapped" object:self.navigationBar.topItem.title];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString* filterName = [dataArray objectAtIndex:indexPath.row]; //Get name of the filter getting created.
    cell.textLabel.text = filterName;
    cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:(122.0/255.0) blue:1.0 alpha:1.0];
    
    if ([self.searchList containsObject:filterName])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else { cell.accessoryType = UITableViewCellAccessoryNone; }
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString* deletedString = [dataArray objectAtIndex:indexPath.row]; //Deletes removed cell from dataArray and whiteList.
        [self.dataArray removeObject:deletedString];
        [self.searchList removeObject:deletedString];

        [self setSearchButtonTitle];
        [self uploadUserDefaults];
        
        [self.tableView reloadData]; //Reload tableView with new dataArray.
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
 
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [self.searchList addObject:cell.textLabel.text];
        NSLog(@"Added: %@ to searchList: %@", cell.textLabel.text, self.searchList);
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self setSearchButtonTitle];
    }
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        [self.searchList removeObject:cell.textLabel.text];
        NSLog(@"Removed: %@", cell.textLabel.text);
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self setSearchButtonTitle];
    }
    
    [self uploadUserDefaults];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSString* cellText = [dataArray objectAtIndex:indexPath.row];
//    selectedRow = indexPath.row;
//    [self openEditFilterView:cellText];
//    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
}
@end
