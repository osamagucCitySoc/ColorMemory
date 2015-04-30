//
//  NoSlotViewController.m
//  ColourMemory
//
//  Created by Osama Rabie on 4/30/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "NoSlotViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface NoSlotViewController ()<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation NoSlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interstitial = [[GADInterstitial alloc] init];
    [self.interstitial setDelegate:self];
    self.interstitial.adUnitID = @"ca-app-pub-2433238124854818/7215102799";
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark gad delegate
-(void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [self.interstitial presentFromRootViewController:self];
}

@end
