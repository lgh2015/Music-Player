//
//  MusicTableViewCell.m
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/10/29.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "UIImageView+WebCache.h"



@implementation MusicTableViewCell

//重写初始化方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化头像图片
        self.backgroundColor=[UIColor clearColor];
        self.photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 4, 56, 56)];
        self.photoImageView.layer.borderWidth=2;
        self.photoImageView.layer.borderColor=[UIColor grayColor].CGColor;
        [self.contentView addSubview:self.photoImageView];
        //初始化歌名的label
        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(86, 10, 250, 20)];
        self.nameLabel.font=[UIFont systemFontOfSize:14];
        self.nameLabel.textColor=[UIColor blackColor];
        self.nameLabel.highlightedTextColor=[UIColor purpleColor];
        //打开用户交互
        self.nameLabel.userInteractionEnabled=YES;
        [self.contentView addSubview:self.nameLabel];
        //初始化歌手的label
        self.singerLabel=[[UILabel alloc]initWithFrame:CGRectMake(86, 40, 250, 15)];
        self.singerLabel.font=[UIFont systemFontOfSize:12];
        self.singerLabel.textColor=[UIColor grayColor];
        self.singerLabel.highlightedTextColor=[UIColor redColor];
        self.singerLabel.userInteractionEnabled=YES;
        [self.contentView addSubview:self.singerLabel];
    }
    return self;
}

-(void)setWithModel:(MusicModel *)model
{
    //对图片进行赋值
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.nameLabel.text=model.name;
    self.singerLabel.text=model.singer;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
