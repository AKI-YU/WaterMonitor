//
//  Global.h
//  WaterMonitor
//
//  Created by AKI on 2015/4/1.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

+(void)addFavoarte:(NSString *)Name;

+(void)removeFavoarte:(NSString *)Name;

+(BOOL)isFavorate:(NSString *)Name;


@end
