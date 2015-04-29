//
//  GuideViewController.m
//  ColourMemory
//
//  Created by Osama Rabie on 4/29/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "GuideViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#define degreesToRadians(x) (M_PI * x / 180.0)

@interface GuideViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;


@property (nonatomic, retain) AVAudioPlayer *myAudioPlayer2;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    

    
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
            [UIView setAnimationRepeatCount:10000];
            [self.circleImageView setTransform:CGAffineTransformMakeRotation(degreesToRadians(90))];
    } completion:nil];
    

    
    self.image1.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.5
                        delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         NSString *soundFilePath2 = [[NSBundle mainBundle] pathForResource:@"button-09" ofType: @"mp3"];
                         NSURL *fileURL2 = [[NSURL alloc] initFileURLWithPath:soundFilePath2 ];
                         self.myAudioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL2 error:nil];
                         self.myAudioPlayer2.numberOfLoops = 0; //infinite loop
                         [self.myAudioPlayer2 play];
                         self.image1.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         self.image1.center = self.image1.center;
                     }
                     completion:nil];
    
    
    self.image2.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         NSString *soundFilePath2 = [[NSBundle mainBundle] pathForResource:@"button-09" ofType: @"mp3"];
                         NSURL *fileURL2 = [[NSURL alloc] initFileURLWithPath:soundFilePath2 ];
                         self.myAudioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL2 error:nil];
                         self.myAudioPlayer2.numberOfLoops = 0; //infinite loop
                         [self.myAudioPlayer2 play];
                         self.image2.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         self.image2.center = self.image2.center;
                     }
                     completion:nil];
    
    self.image3.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5
                          delay:1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         NSString *soundFilePath2 = [[NSBundle mainBundle] pathForResource:@"button-09" ofType: @"mp3"];
                         NSURL *fileURL2 = [[NSURL alloc] initFileURLWithPath:soundFilePath2 ];
                         self.myAudioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL2 error:nil];
                         self.myAudioPlayer2.numberOfLoops = 0; //infinite loop
                         [self.myAudioPlayer2 play];
                         self.image3.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         self.image3.center = self.image3.center;
                     }
                     completion:nil];


    
    
    [self performSelector:@selector(pushSeg) withObject:nil afterDelay:2.5];
    
}

-(void)pushSeg
{
  //  [self.myAudioPlayer stop];
    [self performSegueWithIdentifier:@"gameSeg" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
