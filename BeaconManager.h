//
//  BeaconManager.h
//  iBeaconMonitor
//
//  Created by uehara akihiro on 2013/12/15.
//  Copyright (c) 2013年 REINFORCE Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import "BeaconVO.h"

#define kDefaultUUIDString @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"

typedef enum {
    init    = 0,
    region  = 1,
    ranging = 2
} BeaconManagerStat;

@class BeaconManager;

@protocol BeaconManagerDelegate <NSObject>
@optional
// 状態遷移
-(void)didChangeStat:(BeaconManager *)sender;
// ビーコンのVOが追加された
-(void)didBeaconAdded:(BeaconManager *)sender beacon:(BeaconVO *)beacon;

-(void)didEnterBeaconRegion:(BeaconManager *)sender beacon:(BeaconVO *)beacon;
-(void)didExitBeaconRegion:(BeaconManager *)sender  beacon:(BeaconVO *)beacon;
-(void)didUpdateRanging:(BeaconManager *)sender beacons:(NSArray *)beacons;
@end

@interface BeaconManager : NSObject<CLLocationManagerDelegate>
@property (nonatomic) NSObject<BeaconManagerDelegate> *delegate;
@property (nonatomic) BeaconManagerStat stat;

// 選択されたビーコン
@property (nonatomic) NSArray *selectedBeacons;

//ユニークなmajor番号の配列、番号で昇順ソート
-(NSArray *)majors;
-(NSArray *)beacons:(NSNumber *)major;

+(BeaconManager *)sharedInstance;
@end
