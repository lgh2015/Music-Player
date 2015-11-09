//
//  HL Player.m
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/11/2.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "HL Player.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaToolbox/MediaToolbox.h>//视频

#pragma --mark 单例的初始化方法

@interface HL_Player ()
{
    BOOL _isPlaying;
}
@property(nonatomic,strong)AVPlayer *avplayer;
@property(nonatomic,strong)NSTimer *timer;
@end


@implementation HL_Player

-(instancetype)init
{
    self=[super init];
    if (self) {
        //初始化系统的音乐播放器
        self.avplayer=[[AVPlayer alloc]init];
        //添加观察者,监测音乐有没有播放完毕
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
#pragma --mark 监测音乐播放完毕时执行的方法
-(void)handleEndTimeNotification:(NSNotification *)sender
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(playerDidfinishPlaying:)]) {
        [self.delegate playerDidfinishPlaying:self];
    }
}
#pragma --mark开始播放
-(void)play
{
    _isPlaying=YES;
    [self.avplayer play];
    //创建一个定时器,控制大图的旋转和进度条的更新
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleTimeAction:) userInfo:nil repeats:YES];
}
#pragma --mark  换歌
-(void)setPlayWithUrl:(NSString *)urlString
{
    //1.根据URL创建一个歌曲的播放对象
    AVPlayerItem *Item=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    //用刚刚创建的item替换正在播放的item
    [self.avplayer replaceCurrentItemWithPlayerItem:Item];
}
#pragma  --mark定时器关联的方法
-(void)handleTimeAction:(NSTimer *)sender
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(player:didPlayWithTime:)]) {
        //value/timescale = seconds  文档里面有写
        float time=self.avplayer.currentTime.value/self.avplayer.currentTime.timescale;
        [self.delegate player:self didPlayWithTime:time];
    }
}
#pragma --mark判断当前是否有歌曲播放中
-(BOOL)isPlaying
{
    return  _isPlaying;
}
#pragma --mark暂停
-(void)pause
{
    _isPlaying=NO;
    //让音乐暂停
    [self.avplayer pause];
    //停止定时器
    [self.timer invalidate];
    self.timer=nil;
}
#pragma --mark停止
-(void)stop
{
    //停止的时候要先暂停
    [self pause];
    //滑动到某个时间
    //第一个参数是将时间拖动到几秒
    //第二个参数是时间的总长度
    [self.avplayer seekToTime:CMTimeMake(0, self.avplayer.currentTime.timescale)];
}
#pragma -mark 拖拽音乐播放的进度条,实现音乐进度的控制
-(void)seekToTime:(float)time
{
    //1.先暂停
    [self pause];
    //2.拖动音乐播放的进度条改变时间,把音乐进度条更新后的时间传递过来
    [self.avplayer seekToTime:CMTimeMake(time, 1) completionHandler:^(BOOL finished) {
        if (finished)
        {
            [self play];
        }
    }];
}
+(instancetype)sharePlayer
{
    static HL_Player *play=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        play=[[HL_Player alloc]init];
    });
    return play;
}
-(void)setVolume:(float)volume
{
    self.avplayer.volume=volume;
}
@end
