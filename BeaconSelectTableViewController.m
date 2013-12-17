//
//  BeaconSelectTableViewController.m
//  iBeaconMonitor
//
//  Created by uehara akihiro on 2013/12/15.
//  Copyright (c) 2013年 REINFORCE Lab. All rights reserved.
//

#import "BeaconSelectTableViewController.h"
#import "BeaconCell.h"

@interface BeaconSelectTableViewController () {
    BeaconManager *_manager;
}
@end

@implementation BeaconSelectTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear   = NO;
    self.tableView.allowsMultipleSelection = YES;
    self.navigationController.navigationItem.rightBarButtonItem.enabled = NO;
    
    _manager = [BeaconManager sharedInstance];
    _manager.selectedBeacons = [NSArray array];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _manager.delegate = self;
    _manager.stat = ranging;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark BeaconManagerDelegate
-(void)didBeaconAdded:(BeaconManager *)sender beacon:(BeaconVO *)beacon {
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.navigationController.navigationItem.rightBarButtonItem.enabled = YES;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;

    // ナビゲーション右ボタンを更新
    NSArray *indices    = [self.tableView indexPathsForSelectedRows];
    NSUInteger cnt = [indices count];
    self.navigationController.navigationItem.rightBarButtonItem.enabled = (cnt != 0);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger cnt = [[_manager majors] count];
    return (cnt == 0) ? 1 : cnt;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cnt = [[_manager majors] count];
    if( cnt == 0 ) {
        return 1;
    } else {
        NSArray *majors  = [_manager majors];
        NSNumber *major  = [majors objectAtIndex:section];
        NSArray *beacons = [_manager beacons:major];
        return [beacons count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detectingCellIdentifier = @"detectingLabelCell";
    static NSString *beaconCellIdentifier = @"BeaconCell";

    NSInteger cnt = [[_manager majors] count];
    if( cnt == 0 ) {
        return [tableView dequeueReusableCellWithIdentifier:detectingCellIdentifier forIndexPath:indexPath];
    } else {
        BeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:beaconCellIdentifier forIndexPath:indexPath];
        
        NSUInteger section = [indexPath indexAtPosition:0];
        NSUInteger row     = [indexPath indexAtPosition:1];

        NSArray *majors  = [_manager majors];
        NSNumber *major  = [majors objectAtIndex:section];
        NSArray *beacons = [_manager beacons:major];
        cell.beacon = [beacons objectAtIndex:row];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cnt = [[_manager majors] count];
    return  cnt == 0 ? 148 : 72;
}
#pragma mark Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSMutableArray *ary = [NSMutableArray array];
    NSArray *indices    = [self.tableView indexPathsForSelectedRows];
    for(NSIndexPath *index in indices) {
        BeaconCell *cell = (BeaconCell *)[self.tableView cellForRowAtIndexPath:index];
        [ary addObject:cell.beacon];
    }
    _manager.selectedBeacons = ary;
}
@end
