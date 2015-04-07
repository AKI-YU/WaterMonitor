//
//  Global.m
//  WaterMonitor
//
//  Created by AKI on 2015/4/1.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import "Global.h"

@implementation Global


+(void)addFavoarte:(NSString *)Name{
    
    NSString *favStr = [NSString stringWithFormat:@",%@,",Name];
    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.yuaki.watermore"];
    
    [shared setObject:favStr forKey:@"fav"];
    [shared synchronize];
    
}

+(void)removeFavoarte:(NSString *)Name{
    
    
    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.yuaki.watermore"];
    
    
    NSString *favStr = [shared objectForKey:@"fav"];
    
    
    [shared setObject:[favStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@,",Name] withString:@","] forKey:@"fav"];
    [shared synchronize];
    
}

+(BOOL)isFavorate:(NSString *)Name{
    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.yuaki.watermore"];
    
    NSString *favStr=  [shared objectForKey:@"fav"];
    if(favStr==nil){
        return NO;
    }
    
    if([favStr rangeOfString:[NSString stringWithFormat:@",%@,",Name]].location!=NSNotFound){
        return YES;
    }
    
    return NO;
    
}


@end
