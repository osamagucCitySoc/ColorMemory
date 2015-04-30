//
//  ResultViewController.h
//  ColourMemory
//
//  Created by Osama Rabie on 4/30/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyModalViewControllerDelegate;

@interface ResultViewController : UIViewController
{
    id <MyModalViewControllerDelegate> delegate;
}

@property(nonatomic)float score;
@property (strong) id <MyModalViewControllerDelegate> delegate;

@end

@protocol MyModalViewControllerDelegate <NSObject>

@required

- (void)myModalViewController:(ResultViewController *)controller didFinishSelecting:(NSString *)selectedDog;

@end
