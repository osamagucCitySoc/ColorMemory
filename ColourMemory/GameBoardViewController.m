//
//  GameBoardViewController.m
//  ColourMemory
//
//  Created by OsamaMac on 9/1/14.
//  Copyright (c) 2014 Osama Rabie. All rights reserved.
//

#import "GameBoardViewController.h"

@interface GameBoardViewController ()

@end

@implementation GameBoardViewController
{
    NSMutableArray* countArray;
    NSMutableArray* randomFilledArray;
    NSMutableArray* allAvailbleDataArray;
}

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


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
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self randomizeTheBoard];
}

-(void)randomizeTheBoard
{
    countArray = [[NSMutableArray alloc]init];
    randomFilledArray = [[NSMutableArray alloc]init];
    allAvailbleDataArray = [[NSMutableArray alloc]init];
    
    for(int i = 1 ; i < 9 ; i++)
    {
        [allAvailbleDataArray addObject:[NSString stringWithFormat:@"%i",i]];
        [countArray addObject:@"0"];
    }
    
    
    while(randomFilledArray.count<16 && countArray.count>0)
    {
        int randNum = arc4random() % (countArray.count-1);
        [randomFilledArray addObject:[allAvailbleDataArray objectAtIndex:randNum]];
        int increaseCount = [[countArray objectAtIndex:randNum] intValue]+1;
        if(increaseCount>=2)
        {
            [allAvailbleDataArray removeObjectAtIndex:randNum];
            [countArray removeObjectAtIndex:randNum];
        }
    }
    //NSLog(@"%@",randomFilledArray);
    [self.collectionView reloadData];
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
    
    [(UIImageView*)[cell viewWithTag:1] setAlpha:0.0f];
    
    
    //fade in
    [UIView animateWithDuration:0.5f delay:((CGFloat)indexPath.row/10.0f) options:UIViewAnimationOptionCurveEaseIn animations:^{
        [(UIImageView*)[cell viewWithTag:1] setAlpha:1.0f];
    } completion:^(BOOL finished) {
    }];
    
    cell.layer.shadowColor = [UIColor whiteColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.layer.shadowOpacity = 1;
    cell.layer.shadowRadius = 5.0;
    cell.layer.cornerRadius = 20.0f;
    
    return cell;
    
}

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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval =  CGSizeMake(70, 90);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    [UIView transitionWithView:imageView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@%@",@"colour",[randomFilledArray objectAtIndex:indexPath.row],@".png"]];
                    } completion:^(BOOL finished) {
                        [self startAnimation:cell];
                    }];
}

@end
