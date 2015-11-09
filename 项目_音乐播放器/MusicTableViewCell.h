//
//  MusicTableViewCell.h
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/10/29.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
//#import 解决了重复引用(A导入了C ,B也导入了C,然后A里面导入B,这样C相当于在A的里面导入了两次),在底层进行了判断 封装了不能重复导入
//#imclude
//@class   防止交叉编译,(A B互相导入,编译器),仅仅是告诉编译器有这个类的存在,但是并不能使用这个类里面的东西.

@interface MusicTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *photoImageView;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *singerLabel;

//@property(nonatomic,strong)MusicModel *model;

-(void)setWithModel:(MusicModel *)model;


@end






