//
//  NotificationListViewController.m
//  PHPHub
//
//  Created by Aufree on 9/26/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "NotificationListViewController.h"
#import "NotificationListCell.h"

@interface NotificationListViewController ()

@end

@implementation NotificationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[NotificationListTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
