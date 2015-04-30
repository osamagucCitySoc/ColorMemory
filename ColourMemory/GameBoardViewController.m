//
//  GameBoardViewController.m
//  ColourMemory
//
//  Created by OsamaMac on 9/1/14.
//  Copyright (c) 2014 Osama Rabie. All rights reserved.
//

#import "GameBoardViewController.h"
#import "DatabaseController.h"
#import "CONSTANTS.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ResultViewController.h"

@interface GameBoardViewController ()<GADInterstitialDelegate,MyModalViewControllerDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, retain) AVAudioPlayer *myAudioPlayer;
@property (nonatomic, retain) AVAudioPlayer *myAudioPlayer2;

@end

@implementation GameBoardViewController
{
    
    NSTimer *t;
    
    /**
     Those arrays to be used in randomly filling the board.
     The algorthim written by me is a modified concept of the "index sort" algorithm.
     **/
    NSMutableArray* countArray;//ith entry tells how many times allAvailbleDataArray(i) had been put on the board (0,1,2).
    NSMutableArray* randomFilledArray;//ith entry is a random value from 1-8
    NSMutableArray* allAvailbleDataArray;//ith entry is availbe entry from 1-8 that yet can be added to the board.
    
    /**
     Index pathes are to hold the values of the cards the user flipped if any.
     **/
    NSIndexPath* firstOpenedCard;
    NSIndexPath* secondOpenedCard;
    
    /**
     Those are to hold and show the score.
     **/
    UILabel * scoreLabel;
    float score;
    int matchedAlready;
    BOOL countTime;
    DatabaseController* db; // to be used as interface to database operations.
    int whichCards;
    
    
}

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"scoreModalSeg"])
    {
        ResultViewController* dst = (ResultViewController*)[segue destinationViewController];
        [dst setDelegate:self];
        [dst setScore:score];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"bg" ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
    self.myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    self.myAudioPlayer.numberOfLoops = -1; //infinite loop
    
    countTime = NO;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"headerSection"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeScore:)
                                                 name:@FINISHED_USERNAME_NOTIFICATION_NAME
                                               object:nil];
    
    db = [[DatabaseController alloc]init];
    
    [self initTheGame];
    
    [self.collectionView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"collectionViewBG.png"]]];
    
}



-(void)initTheGame
{
    [self randomizeTheBoard];
    self.interstitial = [[GADInterstitial alloc] init];
    [self.interstitial setDelegate:self];
    self.interstitial.adUnitID = @"ca-app-pub-2433238124854818/7215102799";
    GADRequest *request = [GADRequest request];
    int randomIndex = arc4random() % 20;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomIndex * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.interstitial loadRequest:request];
    });
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



-(void)storeScore:(id)sender
{
    [db insertNewScoredRecord:score];
    [self randomizeTheBoard];
}

/**
 This method is for randomizing the board at the beginning of the game.
 I have implemented a quick tricky algorithm based on the "Index Sort".
 **/

-(void)randomizeTheBoard
{
    whichCards = arc4random()%5;
    
    score = 0;
    matchedAlready = 0;
    
    firstOpenedCard = nil;
    secondOpenedCard = nil;
    
    countArray = [[NSMutableArray alloc]init];
    randomFilledArray = [[NSMutableArray alloc]init];
    allAvailbleDataArray = [[NSMutableArray alloc]init];
    
    for(int i = 1 ; i < 9 ; i++)
    {
        [allAvailbleDataArray addObject:[NSString stringWithFormat:@"%i",i]];
        [countArray addObject:@"0"];
    }
    
    
    while(randomFilledArray.count<16)
    {
        int randNum = arc4random() % (countArray.count);
        [randomFilledArray addObject:[allAvailbleDataArray objectAtIndex:randNum]];
        int increaseCount = [[countArray objectAtIndex:randNum] intValue]+1;
        if(increaseCount>=2)
        {
            [allAvailbleDataArray removeObjectAtIndex:randNum];
            [countArray removeObjectAtIndex:randNum];
        }else
        {
            [countArray replaceObjectAtIndex:randNum withObject:[NSString stringWithFormat:@"%i",increaseCount]];
        }
    }
    [self.collectionView reloadData];
    
}
/**
 This method is for updating the score label whenver needed.
 **/
-(void)updateScoreLabel
{
    [scoreLabel setText:[NSString stringWithFormat:@"%@ : %0.2f s",@"Your Time Is",score]];
    [scoreLabel setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return randomFilledArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cardCell";
    
    UICollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    ((UIImageView*)[cell viewWithTag:1]).image = [UIImage imageNamed:@"card_bg.png"];
    [(UIImageView*)[cell viewWithTag:1] setAlpha:0.0f];
    
    
    //fade in
    [UIView animateWithDuration:0.5f delay:((CGFloat)indexPath.row/10.0f) options:UIViewAnimationOptionCurveEaseIn animations:^{
        [(UIImageView*)[cell viewWithTag:1] setAlpha:1.0f];
        [[(UIImageView*)[cell viewWithTag:1] layer]setShadowColor:[UIColor redColor].CGColor];
        [[(UIImageView*)[cell viewWithTag:1] layer]setShadowRadius:20];
        [(UIImageView*)[cell viewWithTag:1] setClipsToBounds:NO];
        [[(UIImageView*)[cell viewWithTag:1]layer] setMasksToBounds:NO];
    } completion:^(BOOL finished) {
    }];
    
    cell.layer.shadowColor = [UIColor whiteColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.layer.shadowOpacity = 1;
    cell.layer.shadowRadius = 5.0;
    cell.layer.cornerRadius = 20.0f;
    
    
    [cell setUserInteractionEnabled:YES];
    
    return cell;
    
}

/**
 This method is used to shake the currently opened card to catch the user's eye.
 **/
-(void)startAnimation:(UICollectionViewCell*)lockView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1f];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:10000];
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(10));
    lockView.transform = transform;
    [UIView commitAnimations];
    
}

/**
 This method is used to stop the shaking animation on the card when it is reclosed.
 **/
-(void)stopAnimation:(UICollectionViewCell*)lockView
{
    [lockView.layer removeAllAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1f];
    [UIView setAnimationRepeatCount:1];
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
    lockView.transform = transform;
    [UIView commitAnimations];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval =  CGSizeMake(70, 85);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

/**
 This is a delegate method that is being called whenever a user clicks on an item on the board. Possible paths are:
 1- User clicks to flip the first card. So this card is flipped and saved.
 2- User clicks to un-flip an oppened card. So this card is un-flipped and undo saved.
 3- User clicks to flip the second card. So this card is flipped and saved and compared agains the first one. If match increase coins and hide them from the board, if not decrease coins and un-flip them all.
 **/

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    
    if(self.myAudioPlayer2)
    {
        [self.myAudioPlayer2 stop];
    }
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"button-09" ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
    self.myAudioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    self.myAudioPlayer2.numberOfLoops = 0; //infinite loop
    [self.myAudioPlayer2 play];
    
    if(firstOpenedCard != nil)
    {
        if(firstOpenedCard == indexPath) // close opened card
        {
            firstOpenedCard = nil;
            [UIView transitionWithView:imageView
                              duration:0.2
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                imageView.image = [UIImage imageNamed:@"card_bg.png"];
                            } completion:^(BOOL finished) {
                                [self stopAnimation:cell];
                            }];
            
            return;
        }
    }
    
    
    if(secondOpenedCard != nil)
    {
        if(secondOpenedCard == indexPath) // close opened card
        {
            secondOpenedCard = nil;
            [UIView transitionWithView:imageView
                              duration:0.2
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                imageView.image = [UIImage imageNamed:@"card_bg.png"];
                            } completion:^(BOOL finished) {
                                [self stopAnimation:cell];
                            }];
            
            return;
        }
    }
    
    NSString* appendWhichCards = @"";
    if(whichCards > 0)
    {
        appendWhichCards = [NSString stringWithFormat:@"%i",whichCards];
    }

    
    if(firstOpenedCard == nil)
    {//first to open a card
        firstOpenedCard = indexPath;
        [UIView transitionWithView:imageView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@%@%@",appendWhichCards,@"colour",[randomFilledArray objectAtIndex:indexPath.row],@".png"]];
                        } completion:^(BOOL finished) {
                            [self startAnimation:cell];
                        }];
        return;
    }
    
    if(secondOpenedCard == nil)
    {//second to open a card
        [self.collectionView setUserInteractionEnabled:NO];
        secondOpenedCard = indexPath;
        [UIView transitionWithView:imageView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@%@%@",appendWhichCards,@"colour",[randomFilledArray objectAtIndex:indexPath.row],@".png"]];
                        } completion:^(BOOL finished) {
                            [self startAnimation:cell];
                            // need to check for a match and act accordingly
                            if([[randomFilledArray objectAtIndex:firstOpenedCard.row]isEqualToString:[randomFilledArray objectAtIndex:secondOpenedCard.row]])
                            {
                                [self makeTheTwoMatchedUnClickable];
                                //                                [self performSelector:@selector(makeTheTwoMatchedUnClickable) withObject:nil afterDelay:0.5];
                            }else
                            {
                                [self performSelector:@selector(unFlipTheNonMatched) withObject:nil afterDelay:0.2];
                            }
                        }];
        return;
    }
}


-(void)makeTheTwoMatchedUnClickable
{
    matchedAlready++;
    
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:firstOpenedCard];
    [self stopAnimation:cell];
    [cell setUserInteractionEnabled:NO];
    UICollectionViewCell* cell2 = [self.collectionView cellForItemAtIndexPath:secondOpenedCard];
    [self stopAnimation:cell2];
    [cell2 setUserInteractionEnabled:NO];
    
    firstOpenedCard = nil;
    secondOpenedCard = nil;
    [self.collectionView setUserInteractionEnabled:YES];
    
    if(matchedAlready >=8)
    {
        [self performSegueWithIdentifier:@"scoreModalSeg" sender:self];
    }
}

-(void)unFlipTheNonMatched
{
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:firstOpenedCard];
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    [UIView transitionWithView:imageView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        imageView.image = [UIImage imageNamed:@"card_bg.png"];
                    } completion:^(BOOL finished) {
                        [self stopAnimation:cell];
                    }];
    
    UICollectionViewCell* cell2 = [self.collectionView cellForItemAtIndexPath:secondOpenedCard];
    UIImageView* imageView2 = (UIImageView*)[cell2 viewWithTag:1];
    [UIView transitionWithView:imageView2
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        imageView2.image = [UIImage imageNamed:@"card_bg.png"];
                    } completion:^(BOOL finished) {
                        [self stopAnimation:cell2];
                    }];
    
    
    firstOpenedCard = nil;
    secondOpenedCard = nil;
    [self.collectionView setUserInteractionEnabled:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerSection" forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        }
        [reusableview setBackgroundColor:[UIColor clearColor]];
        [scoreLabel removeFromSuperview];
        scoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 30, 200, 15)];
        scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
        scoreLabel.textAlignment = NSTextAlignmentLeft;
        [scoreLabel setBackgroundColor:[UIColor clearColor]];
        [scoreLabel setTextColor:[UIColor whiteColor]];
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(280, 9, 32, 32)];
        [button setImage:[UIImage imageNamed:@"Repeat-32.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(resetClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self updateScoreLabel];
        [reusableview addSubview:scoreLabel];
        [reusableview addSubview:button];
        return reusableview;
    }else if(kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerSection" forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        }
        [reusableview setBackgroundColor:[UIColor clearColor]];
        GADBannerView* bannerView = [[GADBannerView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        bannerView.adUnitID = @"ca-app-pub-2433238124854818/8971037599";
        bannerView.rootViewController = self;
        [bannerView loadRequest:[GADRequest request]];
        [reusableview addSubview:bannerView];
        return reusableview;
        
    }
    return nil;
}

#pragma mark alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        // check if the username is already stored, then store the new score locally.
        // otherwise, first take the username.
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@STORREDUSERNAME])
        {
            [self performSegueWithIdentifier:@"takeNameSeg" sender:self];
        }else
        {
            [self storeScore:nil];
            [self randomizeTheBoard];
        }
    }
}


#pragma mark gad delegate
-(void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [self.interstitial presentFromRootViewController:self];
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"%@",[error description]);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(t)
    {
        [t invalidate];
    }
    t = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                         target: self
                                       selector:@selector(onTick:)
                                       userInfo: nil repeats:YES];
    //[self.myAudioPlayer play];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [t invalidate];
    [self.myAudioPlayer stop];
}

-(void)onTick:(NSTimer *)timer {
    score += 1.0;
    [self updateScoreLabel];
}

-(void)resetClicked:(UIButton*)sender
{
    [self initTheGame];
}

- (void)myModalViewController:(ResultViewController *)controller didFinishSelecting:(NSString *)selectedDog{
    
    [self initTheGame];
    [controller dismissViewControllerAnimated:YES completion:nil];
}





@end
