//
//  TodayViewController.m
//  watertoday
//
//  Created by AKI on 2015/4/1.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "VWWWaterView.h"
#import "Global.h"

#import "TFHpple.h"
#import "TFHppleElement.h"

#define waterURL @"http://fhy.wra.gov.tw/ReservoirPage_2011/StorageCapacity.aspx"




@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(320, 140);
    
    [self checkData];
}

-(void)viewWillAppear:(BOOL)animated{
    if (viewNoData.hidden) {
        [self checkData];
    }
}

-(void)checkData{
    
    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.yuaki.watermore"];
    
    NSString *favStr = [shared objectForKey:@"fav"];
    
    if(favStr==nil || [favStr isEqualToString:@""] || [favStr isEqualToString:@","]){
        [viewNoData setHidden:NO];
        [viewData setHidden:YES];
    }else{
        [viewNoData setHidden:YES];
        [viewData setHidden:NO];
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        
        NSURL *Url = [NSURL URLWithString:waterURL];
        
        NSData *HtmlData = [NSData dataWithContentsOfURL:Url];
        TFHpple *Parser = [TFHpple hppleWithHTMLData:HtmlData];
        
        NSString *XpathQueryString = @"//table[@id='cphMain_gvList']/tr";
        
        NSArray *mArray = [Parser searchWithXPathQuery:XpathQueryString];
        
        if(mArray.count==0){
            [self performSelector:@selector(checkData) withObject:nil afterDelay:10.0f];
            return;
        }
        
        for (int i=0; i<mArray.count; i++) {
            
            NSArray *sArray =[(TFHppleElement *)[mArray objectAtIndex:i] childrenWithTagName:@"td"];
            if(sArray.count!=0){
                
                if([[(TFHppleElement *)[sArray lastObject] text] rangeOfString:@"%"].location !=NSNotFound){
                    [dataArray addObject:[NSString stringWithFormat:@"%@,%@", [(TFHppleElement *)[sArray objectAtIndex:0] text] , [(TFHppleElement *)[sArray lastObject] text]]];
                    
                }
                
            }
        }
        
        int idx = -1;
        for (int i=0; i<dataArray.count; i++) {
            if ([[dataArray objectAtIndex:i] rangeOfString:[favStr stringByReplacingOccurrencesOfString:@"," withString:@""]].location!=NSNotFound) {
                idx = i;
                break;
            }
        }
        if(idx!=-1){
            [viewNoData setHidden:YES];
            [viewData setHidden:NO];
            water.layer.cornerRadius = 50;
            [water setBackgroundColor:[UIColor whiteColor]];
            [water setWaterHeight:[[[[[dataArray objectAtIndex:idx] componentsSeparatedByString:@","] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"%" withString:@""] doubleValue]];
            lblName.text = [[[dataArray objectAtIndex:idx] componentsSeparatedByString:@","] objectAtIndex:0];
            lblPercent.text = [[[dataArray objectAtIndex:idx] componentsSeparatedByString:@","] objectAtIndex:1];
            
        }else{
            [viewNoData setHidden:NO];
            [viewData setHidden:YES];
        }
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
       completionHandler(NCUpdateResultNewData);
}

-(IBAction)btnHome:(id)sender{
    NSURL *url = [NSURL URLWithString:@"waterMonitor://"];
    [self.extensionContext openURL:url completionHandler:nil];
}

@end
