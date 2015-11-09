//
//  HL Player.h
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/11/2.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HL Player.h"

@class HL_Player;
@protocol  HL_PlayerDelegate <NSObject>

//在这个代理方法中创建音乐播放器和进度条
- (void)player:(HL_Player *)player didPlayWithTime:(float)time;
//已经播放完毕时执行的方法
-(void)playerDidfinishPlaying:(HL_Player *)player;

@end


@interface HL_Player : NSObject

@property(nonatomic,weak)id<HL_PlayerDelegate>delegate;

@property(nonatomic)float volume;

//初始化播放器的单例方法
+(instancetype)sharePlayer;
//播放的方法
-(void)play;
//暂停
-(void)pause;
//停止,归零的
-(void)stop;
//根据URL播放歌曲
-(void)setPlayWithUrl:(NSString *)urlString;
//拖拽滑块改变音乐播放的时间
-(void)seekToTime:(float)time;
//是否正在播放
-(BOOL)isPlaying;



@end

