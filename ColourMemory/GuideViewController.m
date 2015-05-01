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
#import "JCDHTTPConnection.h"
#import "NoSlotViewController.h"
#import "FlatButton.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@interface GuideViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@property (weak, nonatomic) IBOutlet FlatButton *StartButton;

@property (nonatomic, retain) AVAudioPlayer *myAudioPlayer2;

@end

@implementation GuideViewController
{
    NSString* segIdent;
    NSString* imageURL;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"noSlotSeg"])
    {
        NoSlotViewController* dst = (NoSlotViewController*)[segue destinationViewController];
        [dst setImageURL:imageURL];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.StartButton setBackgroundColor:[UIColor colorWithRed:0.521569
                                                        green:0.768627
                                                         blue:0.254902 alpha:1]];
    self.StartButton.layer.cornerRadius = 10;
    [self.StartButton setTitle:@"إبدأ التحدي !" forState:UIControlStateNormal];
    self.StartButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:10.0f];
    self.StartButton.alpha = 0;
    [self.StartButton addTarget:self action:@selector(flatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.StartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    segIdent = @"gameSeg";
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://moh2013.com/arabDevs/cartooni/morePrize.php"]];
    
    JCDHTTPConnection *connection = [[JCDHTTPConnection alloc] initWithRequest:request];
    
    [connection executeRequestOnSuccess:
     ^(NSHTTPURLResponse *response, NSString *bodyString) {
         if([bodyString isEqualToString:@"yes"])
         {
             segIdent = @"gameSeg";
         }else
         {
             imageURL = bodyString;
             segIdent = @"noSlotSeg";
         }
     } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
         segIdent = @"gameSeg";
     } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
         //[self initTheGame];
     }];


    
    
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
                     completion:^(BOOL finished){
                         self.StartButton.alpha = 1;
                     }];
   // [self performSelector:@selector(pushSeg) withObject:nil afterDelay:2.5];
}
-(void)flatButtonPressed:(id)button {
    [self pushSeg];
}

-(void)pushSeg
{
  //  [self.myAudioPlayer stop];
    [self performSegueWithIdentifier:segIdent sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)numberWithMin:(int)min max:(int)max
{
    return rand() % (max - min) + min;
}

@end
