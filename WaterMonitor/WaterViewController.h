//
//  WaterViewController.h
//  WaterMonitor
//
//  Created by AKI on 2015/3/31.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UICollectionView *mCollection;
    
    
    
    
    
    
}

@property (nonatomic,retain) NSArray *mArray;

@end
