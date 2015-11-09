//
//  LyricModel.m
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/11/3.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

-(instancetype)initWithCurrentTime:(NSTimeInterval)CurrentTime string:(NSString *)string
{
    if (self=[super init]) {
        self.currentTime=CurrentTime;
        self.string=string;
    }
    return self;
}









@end
