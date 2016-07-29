//
//  ViewController.m
//  iOSExample
//
//  Created by Frank Schmitt on 7/28/16.
//  Copyright © 2016 Apptentive. All rights reserved.
//

#import "ViewController.h"
#import "Apptentive.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITableViewCell *messageCenterCell;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.messageCenterCell.accessoryView = [[Apptentive sharedConnection] unreadMessageCountAccessoryView:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		[[Apptentive sharedConnection] engage:@"event" fromViewController:self];
	} else {
		[[Apptentive sharedConnection] presentMessageCenterFromViewController:self];
	}
}

@end
