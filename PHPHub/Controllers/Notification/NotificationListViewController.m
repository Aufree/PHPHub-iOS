//
//  NotificationListViewController.m
//  PHPHub
//
//  Created by Aufree on 9/26/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "NotificationListViewController.h"
#import "NotificationListCell.h"
#import "NotificationEntity.h"

@interface NotificationListViewController ()
@property (nonatomic, strong) NSMutableArray *notificationEntities;
@property (nonatomic, strong) PaginationEntity *pagination;
@end

@implementation NotificationListViewController

- (void)viewDidLoad {    
    [super viewDidLoad];
    
    self.tableView = [[NotificationListTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (void)setNotificationEntities:(NSMutableArray *)notificationEntities {
    _notificationEntities = notificationEntities;
    self.notificationEntities = _notificationEntities;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
