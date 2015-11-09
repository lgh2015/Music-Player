//
//  LyricModel.h
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/11/3.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

@property(nonatomic,strong)NSString *string;

@property(nonatomic)NSTimeInterval currentTime;

-(instancetype)initWithCurrentTime:(NSTimeInterval)CurrentTime  string:(NSString *)string ;


@end
