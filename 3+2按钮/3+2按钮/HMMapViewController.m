//
//  HMMapViewController.m
//  3+2按钮
//
//  Created by 梅 on 2017/9/15.
//  Copyright © 2017年 mei. All rights reserved.
//

#import "HMMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HMMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong,nonatomic) CLLocationManager *mgr;
@end

@implementation HMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.mgr = [CLLocationManager new];
    [self.mgr requestWhenInUseAuthorization];
//    /*
//     typedef NS_ENUM(NSInteger, MKUserTrackingMode) {
//     MKUserTrackingModeNone = 0, // the user's location is not followed
//     MKUserTrackingModeFollow, // the map follows the user's location
//     MKUserTrackingModeFollowWithHeading __TVOS_PROHIBITED, // the map follows the user's location and heading
//     }
//     */
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.showsScale = YES;//比例尺
    self.mapView.showsTraffic = YES;//交通
    self.mapView.showsCompass = YES;//指南针
}
- (IBAction)actionCloseMap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionOpenCamera:(id)sender {
    
}

- (IBAction)actionBackLocation:(id)sender {
    /*
     typedef struct {
     CLLocationCoordinate2D center;
     MKCoordinateSpan span;
     } MKCoordinateRegion;
     */
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;
    region.span = self.mapView.region.span;
    [self.mapView setRegion:region];//mapview赋值区域
}


@end
