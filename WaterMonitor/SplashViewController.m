//
//  SplashViewController.m
//  WaterMonitor
//
//  Created by AKI on 2015/3/31.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import "SplashViewController.h"
#import "MainViewController.h"
#import "TFHpple.h"
#import "TFHppleElement.h"

#define waterURL @"http://fhy.wra.gov.tw/ReservoirPage_2011/StorageCapacity.aspx"


@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    ErrorCount = 0;
    [self performSelector:@selector(loadData:) withObject:nil afterDelay:0.1f];
    
}

-(void)loadData:(id)sender{
    
    NSURL *wUrl = [NSURL URLWithString:waterURL];
    
    NSData *HtmlData = [NSData dataWithContentsOfURL:wUrl];
    
    
    
    TFHpple *Parser = [TFHpple hppleWithHTMLData:HtmlData];
    
    NSString *XpathQueryString = @"//table[@id='cphMain_gvList']/tr";
    
   NSArray *mArray = [Parser searchWithXPathQuery:XpathQueryString];

    if(mArray.count==0){
        ErrorCount++;
        
        if(ErrorCount>5){
            [[[UIAlertView alloc] initWithTitle:@"網路錯誤" message:@"請檢查網路是否正常,並且重新啟動APP" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil] show];
            return;
        }
        
        [self performSelector:@selector(loadData:) withObject:nil afterDelay:10.0f];
        
        return;
    }

    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<mArray.count; i++) {
        
        NSArray *sArray =[(TFHppleElement *)[mArray objectAtIndex:i] childrenWithTagName:@"td"];
        if(sArray.count!=0){
            
            if([[(TFHppleElement *)[sArray lastObject] text] rangeOfString:@"%"].location !=NSNotFound){
                [dataArray addObject:[NSString stringWithFormat:@"%@,%@", [(TFHppleElement *)[sArray objectAtIndex:0] text] , [(TFHppleElement *)[sArray lastObject] text]]];
                
            }
            
        }
    }
    
    [self performSelector:@selector(gotoMain:) withObject:dataArray afterDelay:0.1f];

}

-(void)gotoMain:(NSArray *)dataArray{
    
    
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    main.dataArray = dataArray;
    
    
    [self.navigationController pushViewController:main animated:YES];
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
