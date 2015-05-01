//
//  NoSlotViewController.m
//  ColourMemory
//
//  Created by Osama Rabie on 4/30/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "NoSlotViewController.h"
#import "MBProgressHUD.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface NoSlotViewController ()<GADInterstitialDelegate,MBProgressHUDDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NoSlotViewController
{
    MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self launchHUD];
    [self showLoader];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            [self hideLoader];
        });
        
    });
    
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

#pragma mark-
#pragma mark-MDProgress HUD
-(void)launchHUD{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
}
- (void)hideLoader {
    [HUD hide:YES afterDelay:0];
}
- (void)showLoader{
    [HUD show:YES];
}

@end
