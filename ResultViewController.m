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

@interface ResultViewController ()<MBProgressHUDDelegate,UIActionSheetDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *teaserImageView;
@end

@implementation ResultViewController
{
    MBProgressHUD *HUD;
    NSString* value1;
    NSString* value2;
    NSString* price;
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
    if(score <= 15)
    {
        title = @"مبرووووووك !!!";
        message = @"أكتب بريدك الإلكتروني لحساب أبل و إسم التطبيق الذي تريده و سيتم الإرسال خلال ٢٤ ساعة";
        inputBoxView.customise = ^(UITextField *textField) {
            textField.placeholder = @"بريدك الإلكتروني لحساب أبل";
            if (textField.secureTextEntry) {
                textField.placeholder = @"التطبيق المراد. أقل من دولارين";
                [textField setSecureTextEntry:NO];
            }
            textField.textColor = [UIColor whiteColor];
            textField.layer.cornerRadius = 4.0f;
            return textField;
        };
        inputBoxView.onSubmit = ^(NSString *value11, NSString *value22) {
            value1 = value11;
            value2 = value22;
            price = @"";
            [self showCountrySelection];
        };
        [self.teaserImageView setImage:[UIImage imageNamed:@"hungry emoticon.png"]];
    }else if(score <= 20)
    {
        title = @"مبرووووووك !!!";
        message = @"أكتب بريدك الإلكتروني لحساب أبل و إسم التطبيق الذي تريده و سيتم الإرسال خلال ٢٤ ساعة";
        inputBoxView.customise = ^(UITextField *textField) {
            textField.placeholder = @"بريدك الإلكتروني لحساب أبل";
            if (textField.secureTextEntry) {
                textField.placeholder = @"التطبيق المراد. أقل من دولار";
                [textField setSecureTextEntry:NO];
            }
            textField.textColor = [UIColor whiteColor];
            textField.layer.cornerRadius = 4.0f;
            return textField;
        };
        inputBoxView.onSubmit = ^(NSString *value11, NSString *value22) {
            value1 = value11;
            value2 = value22;
            price = @"1";
            [self showCountrySelection];
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
    inputBoxView.onSubmit = ^(NSString *value11, NSString *value22) {
       [self.delegate myModalViewController:self didFinishSelecting:@"Abby"];
    };
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


-(void)submitPrize:(NSString*)account app:(NSString*)app pricee:(NSString*)pricee country:(NSString*)country
{
    
    NSString* keyword = [@"OSAMADESC" stringByAppendingFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    NSInteger randomNumber = arc4random() % 25;
    randomNumber++;
    
    for(int i = 1 ; i <= randomNumber ; i++)
    {
        NSData *data = [keyword dataUsingEncoding:NSUTF8StringEncoding];
        keyword = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        data = [account dataUsingEncoding:NSUTF8StringEncoding];
        account = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        data = [app dataUsingEncoding:NSUTF8StringEncoding];
        app = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        data = [pricee dataUsingEncoding:NSUTF8StringEncoding];
        pricee = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        data = [country dataUsingEncoding:NSUTF8StringEncoding];
        country = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    NSString *post = [NSString stringWithFormat:@"contact=%@&app=%@&type=%@&country=%@&keyword=%@",account,app,pricee,country,keyword];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    NSURL *url = [NSURL URLWithString:@"http://moh2013.com/arabDevs/cartooni/addPrize.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:90.0];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLConnection* getResultsConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self    startImmediately:NO];
    
    [getResultsConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                    forMode:NSDefaultRunLoopMode];
    [getResultsConnection start];

}


-(void)showCountrySelection
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"حسابك أبل تابع لأي دولة؟" delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:nil otherButtonTitles:@"أمريكا",@"الكويت",@"السعودية", nil];
    sheet.tag = 1;
    [sheet showInView:self.view];
}


#pragma mark action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1)
    {
        if(buttonIndex == actionSheet.cancelButtonIndex)
        {
            [self.delegate myModalViewController:self didFinishSelecting:@"Abby"];
        }else
        {
            NSString* country = @"";
            if(buttonIndex == 0)
            {
                country = @"أمريكا";
            }else if(buttonIndex == 1)
            {
                country = @"الكويت";
            }else
            {
                country = @"السعودية";
            }
            
            [self showLoader];
            [self submitPrize:value1 app:value2 pricee:@"2" country:country];
        }
    }
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


#pragma mark
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self hideLoader];
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [self.delegate myModalViewController:self didFinishSelecting:@"Abby"];
}


@end
