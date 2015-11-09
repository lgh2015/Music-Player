//
//  MusicalInfoManager.h
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/10/29.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, MusicPlayingStatus) {
    MusicPlayingStatusLoop,
    MusicPlayingStatusRandom,
    MusicPlayingStatusRepeat,
    MusicPlayingStatusNone
};
@interface MusicalInfoManager : NSObject

@property(nonatomic,assign)MusicPlayingStatus playingStatus;



//单例方法
+(instancetype)shareManager;
//获取数据的方法
-(void)acquireData;
//根据下标取model对象
-(id)modelofindex:(NSInteger)index;
//数据的个数
-(NSInteger)modelCount;



@end
