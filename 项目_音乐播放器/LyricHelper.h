//
//  LyricHelper.h
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/11/3.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricHelper : NSObject

//处理歌词的单例方法
+(instancetype)shareLyricHelper;
//处理歌词的方法
-(void)setLyricWithString:(NSString *)string;
//返回处理后的歌词
-(NSMutableArray *)allLyricItems;
//根据时间找到相对应的歌词
//-(NSString *)LyricWithTime:(NSTimeInterval)time;
//根据给定的时间 找到歌词的下标
-(NSInteger)lyricIndexAttime:(NSTimeInterval)time;


@end
