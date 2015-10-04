//
//  SettingsViewController.m
//  PHPHub
//
//  Created by Aufree on 10/4/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "SettingsViewController.h"
#import "TOWebViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 1 ? 100.0f : 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UIViewController *vc;
    
    if (section == 1) {
        switch (row) {
            case 0:
                vc = [[TOWebViewController alloc] initWithURLString:ProjectURL];
                break;
            case 1:
                vc = [[TOWebViewController alloc] initWithURLString:AboutPageURL];
                break;
            case 2:
                vc = [[TOWebViewController alloc] initWithURLString:ESTGroupURL];
                break;
        }
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
