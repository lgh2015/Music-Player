//
//  MusicPlayTableViewController.h
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/10/30.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayTableViewController : UITableViewController

@property(nonatomic,assign)NSInteger currentIndenx;
//block传值的方法 把正在播放的歌曲传过去 确保了按了下一首之后  按红色右侧按钮还是可以识别到当前的歌曲
@property(nonatomic,copy)void(^Block)(NSInteger );


@end
