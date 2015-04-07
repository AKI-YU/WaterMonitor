//
//  WaterViewController.m
//  WaterMonitor
//
//  Created by AKI on 2015/3/31.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import "WaterViewController.h"
#import "mBtn.h"
#import "VWWWaterView.h"
#import "Global.h"


@interface WaterViewController ()

@end

@implementation WaterViewController
@synthesize mArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"MyCustomCell" bundle:nil];
    [mCollection registerNib:cellNib forCellWithReuseIdentifier:@"MyCustomCell"];
       

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [mCollection reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionViewDataSource methods

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCustomCell" forIndexPath:indexPath];
    
    mBtn *btn01 = (mBtn *)[cell viewWithTag:101];
    btn01.idx = (int)indexPath.row;
    [btn01 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    VWWWaterView *water =(VWWWaterView *)[cell viewWithTag:102];
    [water setWaterHeight:[[[[[mArray objectAtIndex:indexPath.row]componentsSeparatedByString:@","] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"%" withString:@""] doubleValue]];
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:103];

    lblName.text = [[[mArray objectAtIndex:indexPath.row]componentsSeparatedByString:@","] objectAtIndex:0];
    
    UILabel *lblPercent = (UILabel *)[cell viewWithTag:104];
    
    lblPercent.text =[[[mArray objectAtIndex:indexPath.row]componentsSeparatedByString:@","] objectAtIndex:1];
    
    UIImageView *imgSelect = (UIImageView *)[cell viewWithTag:106];
    if([Global isFavorate:[[[mArray objectAtIndex:indexPath.row]componentsSeparatedByString:@","] objectAtIndex:0]]){
        [imgSelect setImage:[UIImage imageNamed:@"icon-heart-selected.png"]];
    }else{
        [imgSelect setImage:[UIImage imageNamed:@"icon-heart.png"]];
    }
    
    return cell;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mArray.count;
}

#pragma mark - UICollectionViewDelegate methods

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%d selected", (int)indexPath.row);
}

-(void)btn_click:(mBtn *)sender{
    
    if([Global isFavorate:[[[mArray objectAtIndex:sender.idx]componentsSeparatedByString:@","] objectAtIndex:0]]){
        [Global removeFavoarte:[[[mArray objectAtIndex:sender.idx]componentsSeparatedByString:@","] objectAtIndex:0]];
    }else{
        
        [Global addFavoarte:[[[mArray objectAtIndex:sender.idx]componentsSeparatedByString:@","] objectAtIndex:0]];
    }
    
    [mCollection reloadData];}


@end
