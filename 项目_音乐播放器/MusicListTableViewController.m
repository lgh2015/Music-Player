//
//  MusicListTableViewController.m
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/10/29.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicalInfoManager.h"
#import "MusicModel.h"
//SDWebimage里面的
#import "UIImageView+WebCache.h"
#import "MusicTableViewCell.h"
#import "MusicPlayTableViewController.h"

@interface MusicListTableViewController ()
@property (nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)NSString *stringgg;
@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.设置标题
    self.navigationItem.title=@"音乐列表";
    //2.初始化背景视图
    self.imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    //3.对背景视图赋值
    self.imageView.image=[UIImage imageNamed:@"background640*1136@2x.jpg"];
    //4.将背景视图添加到tableView上
    self.tableView.backgroundView=self.imageView;
    //5.实现模糊效果,创建模糊效果
    UIVisualEffectView *visualView=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    //6.设置模糊效果的大小
    visualView.frame=[UIScreen mainScreen].bounds;
    //7.模糊效果对谁起作用
    [self.imageView addSubview:visualView];
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData:) name:@"KdataDidFinishAcquire" object:nil];
    //创建manager对象,这一行代码必须在注册之后
    [[MusicalInfoManager shareManager] acquireData];
    [self.tableView registerClass:[MusicTableViewCell class] forCellReuseIdentifier:@"identifier"];
    self.tableView.separatorColor=[UIColor clearColor];
    
    //创建导航栏的右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"musicalnote-s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnAction:)];
}
//点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //先判断播放的视图控制器是否已经存在了
    MusicPlayTableViewController *musicPlayVC;
    if (!musicPlayVC) {
        musicPlayVC=[[MusicPlayTableViewController alloc]init];
    }
//    //bolck传值 把正在播放的歌曲的下标传过来
    __block MusicListTableViewController *v=self;
    musicPlayVC.Block=^(NSInteger denx){
        v.indexxx=denx;
    };
    musicPlayVC.currentIndenx=indexPath.row;
    [self.navigationController presentViewController:musicPlayVC animated:YES completion:nil];
}
#pragma mark---导航栏右侧按钮的方法
-(void)navRightBtnAction:(UIBarButtonItem *)sender
{
    //先判断播放的视图控制器是否已经存在了
    MusicPlayTableViewController *musicPlayVC;
    if (!musicPlayVC) {
        musicPlayVC=[[MusicPlayTableViewController alloc]init];
    }
    //bolck传值 把正在播放的歌曲的下标传过来,这里重新赋值确保
    __block MusicListTableViewController *v=self;
    musicPlayVC.Block=^(NSInteger denx){
        v.indexxx=denx;
    };
    musicPlayVC.currentIndenx=self.indexxx;
    NSLog(@"%ld",self.indexxx);
    [self.navigationController presentViewController:musicPlayVC animated:YES completion:nil];
    
    
}


#pragma mark----收到通知之后执行的方法
-(void)reloadData:(NSNotification *)notification
{
    //封装的特性,将所有相关的功能或者代码集中在一个类里面去实现
    MusicModel *model=[[MusicalInfoManager shareManager]modelofindex:0];
    [self.imageView   sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"KdataDidFinishAcquire" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [[MusicalInfoManager shareManager]modelCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.创建cell
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    //2.获取model对象
    MusicModel *model=[[MusicalInfoManager shareManager]modelofindex:indexPath.row];
    //3.将model对象赋值给cell
    [cell setWithModel:model];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}










@end
