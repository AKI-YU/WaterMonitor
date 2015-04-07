//
//  SettingViewController.m
//  WaterMonitor
//
//  Created by AKI on 2015/3/31.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import "SettingViewController.h"
#import "mBtn.h"
#import "Global.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize mArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [mScroll setContentSize:CGSizeMake(960, 200)];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [mTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------------------------------------------------------
#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mArray.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *cellIDT = [NSString stringWithFormat:@"TableViewCell-%ld",(long)indexPath.row];
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIDT];
    
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDT];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FavorateCell" owner:self options:nil];
        UIView *titleView = [topLevelObjects objectAtIndex:0];
        titleView.tag = 999;
        [cell addSubview:titleView];
        
        
    }
    
    UIView *thisView = (UIView *)[cell viewWithTag:999];
    UILabel *lblName = (UILabel *)[thisView viewWithTag:101];
    UILabel *lblPercent = (UILabel *)[thisView viewWithTag:102];
    UIImageView *imgSelect = (UIImageView *)[thisView viewWithTag:103];
    mBtn *btn01 = (mBtn *)[thisView viewWithTag:104];
    
    
    lblName.text = [[[mArray objectAtIndex:indexPath.row]componentsSeparatedByString:@","] objectAtIndex:0];
    
    btn01.idx = (int)indexPath.row;
    [btn01 addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
   
    
    lblPercent.text =[[[mArray objectAtIndex:indexPath.row]componentsSeparatedByString:@","] objectAtIndex:1];
    
    if([Global isFavorate:[[[mArray objectAtIndex:indexPath.row]componentsSeparatedByString:@","] objectAtIndex:0]]){
        [imgSelect setImage:[UIImage imageNamed:@"icon-heart-selected.png"]];
    }else{
        [imgSelect setImage:[UIImage imageNamed:@"icon-heart.png"]];
    }
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

-(void)btn_click:(mBtn *)sender{
    
    if([Global isFavorate:[[[mArray objectAtIndex:sender.idx]componentsSeparatedByString:@","] objectAtIndex:0]]){
        [Global removeFavoarte:[[[mArray objectAtIndex:sender.idx]componentsSeparatedByString:@","] objectAtIndex:0]];
    }else{
        
        [Global addFavoarte:[[[mArray objectAtIndex:sender.idx]componentsSeparatedByString:@","] objectAtIndex:0]];
    }

    [mTable reloadData];
    
}
#pragma mark --------------------------------------------------------

-(void)btnHideHint:(id)sender{
    [viewHint removeFromSuperview];
}

-(IBAction)btnShowHint:(id)sender{
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ViewHint" owner:self options:nil];
    viewHint = [topLevelObjects objectAtIndex:0];
    
    UIButton *btnClose = (UIButton *)[viewHint viewWithTag:103];
    [btnClose addTarget:self action:@selector(btnHideHint:) forControlEvents:UIControlEventTouchUpInside];
    
    mScroll = (UIScrollView *)[viewHint viewWithTag:101];
    mScroll.delegate= self;
    [mScroll setContentSize:CGSizeMake(960, 200)];
    
    mPage = (UIPageControl *)[viewHint viewWithTag:102];
    
    [[[self parentViewController] parentViewController].view addSubview:viewHint];
    
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if(sender.tag==101){
        CGFloat width = mScroll.frame.size.width;
        NSInteger currentPage = ((mScroll.contentOffset.x - width / 2) / width) + 1;
        [mPage setCurrentPage:currentPage];
    }
}

@end
