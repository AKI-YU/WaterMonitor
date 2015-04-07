//
//  TodayViewController.h
//  watertoday
//
//  Created by AKI on 2015/4/1.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VWWWaterView.h"


@interface TodayViewController : UIViewController
{
    IBOutlet UILabel *lblNoData;
    IBOutlet UIButton *btnHome;
    IBOutlet VWWWaterView *water;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblPercent;
    
    IBOutlet UIView *viewNoData;
    
    IBOutlet UIView *viewData;
    
}
@end
