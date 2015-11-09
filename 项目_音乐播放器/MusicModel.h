//
//  MusicModel.h
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/10/29.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property(nonatomic,strong)NSString *mp3Url;

@property(nonatomic,strong)NSNumber *identifier;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *picUrl;

@property(nonatomic,strong)NSString *blurPicUrl;

@property(nonatomic,strong)NSString *album;

@property(nonatomic,strong)NSString *singer;

@property(nonatomic,strong)NSString *duration;

@property(nonatomic,strong)NSString *artists_name;

@property(nonatomic,strong)NSString *lyric;
#pragma  mark--因为使用系统的setvalueAndKeys不能直接对这个model赋值,因为我们修改了id这个属性 所以我们创建该方法对model类赋值
+(instancetype)musicInfoWithDictioray:(NSDictionary *)dict;

@end
