//
//  JMPreferencesViewController.h
//  Locales
//
//  Created by Jayant Madugula on 8/9/14.
//  Copyright (c) 2014 Jayant Madugula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface JMPreferencesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
{
    IBOutlet UISegmentedControl *distanceControl;
}
@property (strong, nonatomic) IBOutlet UITableView *theTableView;
- (IBAction)changeDistance:(id)sender;
- (void)sendSupportEmail;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
