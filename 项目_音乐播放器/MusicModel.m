//
//  MusicModel.m
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/10/29.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
+(instancetype)musicInfoWithDictioray:(NSDictionary *)dict
{
    MusicModel *musicmodel=[[MusicModel alloc]init];
    musicmodel.mp3Url=dict[@"mp3Url"];
    musicmodel.identifier=dict[@"id"];
    musicmodel.name=dict[@"name"];
    musicmodel.picUrl=dict[@"picUrl"];
    musicmodel.blurPicUrl=dict[@"blurPicUrl"];
    musicmodel.album=dict[@"album"];
    musicmodel.singer=dict[@"singer"];
    musicmodel.duration=dict[@"duration"];
    musicmodel.artists_name=dict[@"artists_name"];
    musicmodel.lyric=dict[@"lyric"];
    return  musicmodel;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
