//
//  ResultViewController.m
//  ColourMemory
//
//  Created by Osama Rabie on 4/30/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "ResultViewController.h"
#import "MKInputBoxView.h"
#import "JCDHTTPConnection.h"
#import "MBProgressHUD.h"

@interface ResultViewController ()<MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *teaserImageView;
@end

@implementation ResultViewController
{
    MBProgressHUD *HUD;
}

@synthesize score;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self launchHUD];
    
    MKInputBoxView *inputBoxView = [MKInputBoxView boxOfType:LoginAndPasswordInput];
    [inputBoxView setBlurEffectStyle:UIBlurEffectStyleExtraLight];
    NSString* title = @"";
    NSString* message = @"";
    if(score <= 20)
    {
        title = @"مبرووووووك !!!";
        message = @"أكتب حسابك بتويتر أو بريدك الإلكتروني و إسم التطبيق الذي تريده و سيتم الإرسال خلال ٢٤ ساعة";
        inputBoxView.customise = ^(UITextField *textField) {
            textField.placeholder = @"بريدك أو حسابك بتويتر";
            if (textField.secureTextEntry) {
                textField.placeholder = @"التطبيق المراد. أقل من دولارين";
                [textField setSecureTextEntry:NO];
            }
            textField.textColor = [UIColor whiteColor];
            textField.layer.cornerRadius = 4.0f;
            return textField;
        };
        inputBoxView.onSubmit = ^(NSString *value1, NSString *value2) {
            [self showLoader];
            [self submitPrize:value1 app:value2 price:@"2"];
        };
        [self.teaserImageView setImage:[UIImage imageNamed:@"hungry emoticon.png"]];
    }else if(score <= 30)
    {
        title = @"مبرووووووك !!!";
        message = @"أكتب حسابك بتويتر أو بريدك الإلكتروني و إسم التطبيق الذي تريده و سيتم الإرسال خلال ٢٤ ساعة";
        inputBoxView.customise = ^(UITextField *textField) {
            textField.placeholder = @"بريدك أو حسابك بتويتر";
            if (textField.secureTextEntry) {
                textField.placeholder = @"التطبيق المراد. أقل من دولار";
                [textField setSecureTextEntry:NO];
            }
            textField.textColor = [UIColor whiteColor];
            textField.layer.cornerRadius = 4.0f;
            return textField;
        };
        inputBoxView.onSubmit = ^(NSString *value1, NSString *value2) {
            [self showLoader];
            [self submitPrize:value1 app:value1 price:@"1"];
        };
        [self.teaserImageView setImage:[UIImage imageNamed:@"hungry emoticon.png"]];
    }else
    {
        inputBoxView.customise = ^(UITextField *textField) {
            textField.alpha = 0;
            return textField;
        };
        
        title = @"حاول مرة أخرى :(";
        message = @"إلعب مرة أخرى مجانا و لا تفقد الأمل !";
        [self.teaserImageView setImage:[UIImage imageNamed:@"tongue out emoticon.png"]];
    }
    inputBoxView.onCancel = ^()
    {
        [self.delegate myModalViewController:self didFinishSelecting:@"Abby"];
    };
    [inputBoxView setSubmitButtonText:@"تم"];
    [inputBoxView setCancelButtonText:@"إلغاء"];
    [inputBoxView setTitle:title];
    [inputBoxView setMessage:message];
    [inputBoxView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)submitPrize:(NSString*)account app:(NSString*)app price:(NSString*)price
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://moh2013.com/arabDevs/cartooni/addPrize.php?contact=%@&app=%@&type=%@",account,app,price]]];
    
    JCDHTTPConnection *connection = [[JCDHTTPConnection alloc] initWithRequest:request];
    
    [connection executeRequestOnSuccess:
     ^(NSHTTPURLResponse *response, NSString *bodyString) {
         [self.delegate myModalViewController:self didFinishSelecting:@"Abby"];
     } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
         [self.delegate myModalViewController:self didFinishSelecting:@"Abby"];
     } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
         //[self initTheGame];
     }];
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
