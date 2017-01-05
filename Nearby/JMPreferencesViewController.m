//
//  JMPreferencesViewController.m
//  Locales
//
//  Created by Jayant Madugula on 8/9/14.
//  Copyright (c) 2014 Jayant Madugula. All rights reserved.
//

#import "JMPreferencesViewController.h"

@interface JMPreferencesViewController ()

@end

@implementation JMPreferencesViewController

@synthesize theTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSNumber* distanceNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"Distance Num"];
    if ([distanceNum floatValue] == 0.5)
    {
        distanceControl.selectedSegmentIndex = 0;;
    }
    else if ([distanceNum floatValue] == 1.0)
    {
        distanceControl.selectedSegmentIndex = 1;
    }
    else if ([distanceNum floatValue] == 5.0)
    {
        distanceControl.selectedSegmentIndex = 2;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeDistance:(id)sender
{
    UISegmentedControl* distControl = sender;
    NSNumber* num = [[NSNumber alloc] init];
    if (distControl.selectedSegmentIndex == 0)
    {
        num = [NSNumber numberWithFloat:0.5];
    }
    else if (distControl.selectedSegmentIndex == 1)
    {
        num = [NSNumber numberWithFloat:1.0];
    }
    else if (distControl.selectedSegmentIndex == 2)
    {
        num = [NSNumber numberWithFloat:5.0];
    }
    int distanceInt = [num intValue];
    NSNumber* distanceNum = [[NSNumber alloc] initWithInt:distanceInt];
    [[NSUserDefaults standardUserDefaults] setObject:distanceNum forKey:@"Distance Num"];
}

- (IBAction)resetFilters:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Are you sure want to reset the app to factory settings? This cannot be undone." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset", nil];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self resetAllFilters];
    }
}

- (void)resetAllFilters
{
    NSMutableDictionary* searchDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Search Dictionary"] mutableCopy];
    NSMutableDictionary* dataDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Data Dictionary"] mutableCopy];
    
    searchDict = nil;
    dataDict = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:searchDict forKey:@"Search Dictionary"];
    [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"Data Dictionary"];
}

- (void)sendSupportEmail
{
    if ([MFMailComposeViewController canSendMail] == YES)
    {
        MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        NSArray* toRecipient = [[NSArray alloc] initWithObjects:@"localesapp@gmail.com", nil];
        [mailVC setToRecipients:toRecipient];
        mailVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:mailVC animated:YES completion:NULL];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Can't Send Email" message:@"Uh oh! Your device is stopping me from sending an email. Be sure you have set-up the email app." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    if (result == MFMailComposeResultFailed)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message Failed!" message:@"Your message didn't send! Make sure you're signed in to your email in the mail app and try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text =  @"Locales Website";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Support Email";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        NSURL* websiteURL = [[NSURL alloc] initWithString:@"http://localesapp.squarespace.com"]; // Note: website doesn't exist anymore
        [[UIApplication sharedApplication] openURL:websiteURL];
    }
    else if (indexPath.row == 1)
    {
        [self sendSupportEmail];
    }
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

