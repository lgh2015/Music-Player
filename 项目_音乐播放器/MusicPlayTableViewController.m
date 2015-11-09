//
//  MusicPlayTableViewController.m
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/10/30.
//  Copyright © 2015年 LiGuoHao. All rights reserved.

#import "MusicPlayTableViewController.h"
#import "MusicListTableViewController.h"
#import "MusicalInfoManager.h"
#import "MusicModel.h"
#import "HL Player.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "LyricHelper.h"
#import "LyricModel.h"

#define SCREENWIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT     [UIScreen mainScreen].bounds.size.height
//控制台的高度
#define CONTROLBARHEIGHT    300
//控制台的Y轴的起点
#define CONTROBARORIGINY  (SCREENHEIGHT-300)
//带参数的宏定义
#define HLCOLOR(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

@interface MusicPlayTableViewController ()<HL_PlayerDelegate>
//显示图片的转动和歌词的
@property(nonatomic,strong)UIScrollView *scrollView;
//旋转的图片
@property(nonatomic,strong)UIImageView *revolveView;
//调节音乐进度的滑块控件
@property(nonatomic,strong)UISlider *sliderView;
//当前播放到第几秒的label
@property(nonatomic,strong)UILabel *currentTimeLable;
@property(nonatomic,strong)UILabel *remainTimeLable;
//显示歌名的label
@property(nonatomic,strong)UILabel *singNameLabel;
//显示专辑名字的label
@property(nonatomic,strong)UILabel *albumLabel;
//音量
@property(nonatomic,strong)UISlider *voiceSlider;
@property(nonatomic,strong)NSMutableArray *settingBtnArr;
//当前的音乐
@property(nonatomic,strong)MusicModel *currentMusic;
//歌词的tebleView
@property(nonatomic,strong)UITableView *lyricTbableView;

//接收歌词的数组
@property(nonatomic,strong)NSMutableArray *lyricArr;
@end
@implementation MusicPlayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.设置模糊效果
    {
    self.view=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.userInteractionEnabled=YES;
    }
    
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageV.image=[UIImage imageNamed:@"Furious7.jpg"];
    [self.view addSubview:imageV];

    //2.对背景视图设置模糊效果
    {
    UIVisualEffectView *visualView=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark ]];
    visualView.frame=self.view.frame;
    [self.view addSubview:visualView];
    }
    
    //4.实现scrollView的是实现
    {
        self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-CONTROLBARHEIGHT)];
        self.scrollView.delegate=self;
        self.scrollView.contentSize=CGSizeMake(SCREENWIDTH*2, SCREENHEIGHT-CONTROLBARHEIGHT);
        self.scrollView.pagingEnabled=YES;
        [self.view addSubview:self.scrollView];
    }
    
    
    //3.设置控制台
    {
    UIVisualEffectView *controlBarVV=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    controlBarVV.frame=CGRectMake(0, CONTROBARORIGINY, SCREENWIDTH, CONTROLBARHEIGHT);
    [self.view addSubview:controlBarVV];
    }
    //5.创建返回按钮 要放在scrollView的层级关系的上面
    {
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor=[UIColor lightGrayColor];
    backBtn.frame=CGRectMake(16, 24, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
    backBtn.layer.cornerRadius=10;
    [self.view addSubview:backBtn];
    backBtn.layer.masksToBounds=YES;
    [backBtn addTarget:self action:@selector(handleDismissAction:) forControlEvents:UIControlEventTouchDown];
    }
    //6.创建圆形旋转图像
    {
    self.revolveView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 50, SCREENWIDTH-80, SCREENWIDTH-80)];
    self.revolveView.layer.cornerRadius=(SCREENWIDTH-80)/2;
    self.revolveView.layer.masksToBounds=YES;
    self.revolveView.backgroundColor=[UIColor grayColor];
    [self.scrollView addSubview:self.revolveView];
    }
    //7.创建控制音乐进度的滑块控件
    {
    self.sliderView=[[UISlider alloc]initWithFrame:CGRectMake(0, CONTROBARORIGINY-15, SCREENWIDTH, 30)];
    self.sliderView.minimumTrackTintColor=[UIColor purpleColor];
    self.sliderView.maximumTrackTintColor=[UIColor whiteColor];
    [self.sliderView setThumbImage:[UIImage imageNamed:@"volumn_slider_thumb@2x"] forState:UIControlStateNormal];
    [self.view addSubview:self.sliderView];
    [self.sliderView addTarget:self action:@selector(handleProgressChangeAction:) forControlEvents:UIControlEventValueChanged];
    }
    //8.创建当前和剩余时间的label
    {
    self.currentTimeLable=[[UILabel alloc]initWithFrame:CGRectMake(10, CONTROBARORIGINY+15, 100, 20)];
    self.currentTimeLable.font=[UIFont systemFontOfSize:14];
    self.currentTimeLable.textAlignment=NSTextAlignmentLeft;
    self.currentTimeLable.text=@"0:00";
    [self.view addSubview:self.currentTimeLable];
    self.remainTimeLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-110, CONTROBARORIGINY+15, 100, 20)];
    self.remainTimeLable.text=@"0:00";
    [self.view addSubview:self.remainTimeLable];
    self.remainTimeLable.textAlignment=NSTextAlignmentRight;
    self.remainTimeLable.font=[UIFont systemFontOfSize:14];
    }
    //10.创建显示歌名的label
    {
    self.singNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CONTROBARORIGINY+45, SCREENWIDTH, 25)];
    self.singNameLabel.font=[UIFont systemFontOfSize:14];
    self.singNameLabel.textAlignment=NSTextAlignmentCenter;
    self.singNameLabel.text=[[[MusicalInfoManager shareManager]modelofindex:self.currentIndenx] name];
    [self.view addSubview:self.singNameLabel];
    }
    //11.创建专辑名字
    {
    self.albumLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CONTROBARORIGINY+70, SCREENWIDTH, 25)];
    self.albumLabel.textAlignment=NSTextAlignmentCenter;
    self.albumLabel.font=[UIFont systemFontOfSize:14];
    self.albumLabel.backgroundColor=[UIColor whiteColor];
    self.albumLabel.text=@"12313";
    [self.view addSubview:self.albumLabel];
    }
    //12.创建暂停播放按钮
    {
    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    button1.center=CGPointMake(SCREENWIDTH/2, CONTROBARORIGINY+150);
    [button1 setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"pause_h.png"] forState:UIControlStateHighlighted];
    [button1 addTarget:self action:@selector(handlePauseAndPlay:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button1];
    }
    //13.创建上一首音乐按钮
    {
    UIButton *button2=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    button2.center=CGPointMake(SCREENWIDTH/4, CONTROBARORIGINY+150);
    [button2 setImage:[UIImage imageNamed:@"rewind.png"] forState:  UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"rewind_h.png"] forState:UIControlStateHighlighted];
    [button2 addTarget:self action:@selector(handleRewindAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    }
    //14.创建下一首音乐按钮
    {
    UIButton *button3=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    button3.center=CGPointMake( SCREENWIDTH/1.35, CONTROBARORIGINY+150);
    [button3 setImage:[UIImage imageNamed:@"forward.png"] forState:  UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"forward_h.png"] forState:UIControlStateHighlighted];
    [button3 addTarget:self action:@selector(handleForwardAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    }
    //15.声音滑块
    {
    self.voiceSlider=[[UISlider alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-40, 20)];
    self.voiceSlider.center=CGPointMake(SCREENWIDTH/2, CONTROBARORIGINY+200);
    //设置中间的原点图片
    [self.voiceSlider setThumbImage:[UIImage imageNamed:@"volumn_slider_thumb@2x.png"] forState:UIControlStateNormal];
    }
    //设置音量的最大值和最小值
    {
    self.voiceSlider.maximumValue=1;
    self.voiceSlider.minimumValue=0;
        self.voiceSlider.value=1;
        self.voiceSlider.minimumTrackTintColor=[UIColor purpleColor];
    self.voiceSlider.maximumValueImage=[UIImage imageNamed:@"volumehigh@2x.png"];
    self.voiceSlider.minimumValueImage=[UIImage imageNamed:@"volumelow@3x.png"];
    [self.voiceSlider addTarget:self action:@selector(handleVoiceChangeAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.voiceSlider];
    }
    //16.设置播放模式的按钮
    {
    self.settingBtnArr=[[NSMutableArray alloc]init];
    NSArray *titleArray=@[@"loop",@"shuffle",@"singleloop",@"music"];
    for (int i=0; i<titleArray.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonSpace=(SCREENWIDTH-30*4)/3;
        button.frame=CGRectMake(i*(30+buttonSpace), CONTROBARORIGINY+265, 30, 33) ;
        button.tag=10086+i;
        [button setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[titleArray[i] stringByAppendingString:@"-s"] ] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:button];
        [self.settingBtnArr addObject:button];
    }
    }
    //17.创建歌词的tableview
    {
    self.lyricTbableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-CONTROLBARHEIGHT) style:UITableViewStylePlain];
    self.lyricTbableView.delegate=self;
    self.lyricTbableView.dataSource=self;
    [self.scrollView addSubview:self.lyricTbableView];
    [self.lyricTbableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.lyricTbableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.lyricTbableView.contentInset=UIEdgeInsetsMake(200, 0, 0, 0);
    self.lyricTbableView.backgroundColor=[UIColor clearColor];
    }
    [self reloadMusic];
}
#pragma mark---改变播放模式的执行方法
-(void)handleButtonAction:(UIButton *)sender
{
    for (UIButton *btn in self.settingBtnArr) {
        btn.selected=NO;
    }
    [sender setSelected:YES];
    //把点击播放模式按钮的状态赋值给manager里面的属性,让其记录当前的播放模式
    [MusicalInfoManager shareManager].playingStatus=[self.settingBtnArr indexOfObject:sender];
    NSLog(@"%lu",(unsigned long)[self.settingBtnArr indexOfObject:sender]);
}
#pragma mark---改变声音大小滑块的执行方法
-(void)handleVoiceChangeAction:(UISlider *)sender
{
    [HL_Player sharePlayer].volume=sender.value;
    
}
#pragma mark---点击下一首音乐执行的方法
-(void)handleForwardAction:(UIButton *)button
{
    NSInteger st=[MusicalInfoManager shareManager].playingStatus;
    switch (st) {
        case 0:
        {
            //顺序播放
            self.currentIndenx++;
            if (self.currentIndenx==[[MusicalInfoManager shareManager]modelCount]) {
                self.currentIndenx=0;
            }
            break;
        }
        case 1:
        {
             NSInteger index=arc4random()%[[MusicalInfoManager shareManager]modelCount];
            self.currentIndenx=index;
            break;
        }
        case 2:
        {
            //单曲循环不用写操作
            break;
        }
        case 3:
        {
            //列表播放  最后一首之后终止
            self.currentIndenx++;
            if (self.currentIndenx==[[MusicalInfoManager shareManager]modelCount])
            {
                [[HL_Player sharePlayer]stop];
                self.currentIndenx=[[MusicalInfoManager shareManager]modelCount]-1;
                //停止的时候要有推出
                return;
            }
            break;
        }
        default:
            break;
    }
    [self reloadSong];
}
#pragma mark---点击上一首音乐执行的方法
-(void)handleRewindAction:(UIButton *)button
{
    self.currentIndenx--;
    if (self.currentIndenx<0) {
        self.currentIndenx=[[MusicalInfoManager shareManager]modelCount]-1;
    }
    [self reloadSong];
}
#pragma mark---点击播放执行的方法
-(void)handlePauseAndPlay:(UIButton *)sender
{
    //先创建一个音乐播放器
    HL_Player *player=[HL_Player sharePlayer];
    if ([player isPlaying]) {
        //能进到if语句说明正在播放
        [player pause];
        [sender setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"play_h.png"] forState:UIControlStateHighlighted];
    }
    else{
        [player play];
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"pause_h.png"] forState:UIControlStateHighlighted];
    }
}
#pragma mark--滑动播放进度条的方法
-(void)handleProgressChangeAction:(UISlider *)slider
{
    [[HL_Player sharePlayer]seekToTime:slider.value];
}
#pragma mark--返回键执行的方法
-(void)handleDismissAction:(UIButton *)button
{
    self.Block(self.currentIndenx);
    [self dismissViewControllerAnimated:YES completion:nil];
}
//设置播放器
-(void)reloadMusic
{
    NSUserDefaults *currentSong=[NSUserDefaults standardUserDefaults];
    //如果播放时进入的还是那首歌的话 就接着播放
    if ([[HL_Player sharePlayer]isPlaying] && [self.singNameLabel.text
                                               isEqualToString:[currentSong objectForKey:@"name"]]) {
        //1.拿到需要播放得到歌曲
        self.currentMusic=[[MusicalInfoManager shareManager] modelofindex:self.currentIndenx];
        //2.对旋转的图片进行赋值
        [self.revolveView sd_setImageWithURL:[NSURL URLWithString:self.currentMusic.picUrl]];
        //3.对音乐播放的进度条进行赋值
        self.sliderView.maximumValue=[self.currentMusic.duration floatValue]/1000;
        //4.对结束时间进行重新赋值
        self.remainTimeLable.text=[self timeWithInterVal:self.sliderView.maximumValue];
        self.albumLabel.text=self.currentMusic.album;
        //播放音乐
        HL_Player *player=[HL_Player sharePlayer];
        //当前视图控制前当播放器的代理
        player.delegate=self;
        //对歌词的处理
        LyricHelper *helper=[LyricHelper shareLyricHelper];
        [helper setLyricWithString:self.currentMusic.lyric];
        //初始化歌词的数据
        self.lyricArr=[[LyricHelper shareLyricHelper] allLyricItems];
        [self.lyricTbableView reloadData];
    }
    else
    {
        [self reloadSong];
    }
}

-(void)reloadSong{
    //1.拿到需要播放得到歌曲
    self.currentMusic=[[MusicalInfoManager shareManager] modelofindex:self.currentIndenx];
    //2.对旋转的图片进行赋值
    [self.revolveView sd_setImageWithURL:[NSURL URLWithString:self.currentMusic.picUrl]];
    //3.对音乐播放的进度条进行赋值
    self.sliderView.maximumValue=[self.currentMusic.duration floatValue]/1000;
    //4.对结束时间进行重新赋值
    self.remainTimeLable.text=[self timeWithInterVal:self.sliderView.maximumValue];
    //5.对歌手进行赋值
    self.singNameLabel.text=self.currentMusic.name;
    self.albumLabel.text=self.currentMusic.album;
    NSUserDefaults *currentSong=[NSUserDefaults standardUserDefaults];
    [currentSong setObject:self.singNameLabel.text forKey:@"name"];
    //播放音乐
    HL_Player *player=[HL_Player sharePlayer];
    //当前视图控制前当播放器的代理
    player.delegate=self;
    if ([[HL_Player sharePlayer]isPlaying]) {
        //再播放新的歌曲之前要先停掉之前的音乐播放,不然定时器会越走越快
        [player pause];
    }
    [player setPlayWithUrl:self.currentMusic.mp3Url];
    //对歌词的处理
    LyricHelper *helper=[LyricHelper shareLyricHelper];
    [helper setLyricWithString:self.currentMusic.lyric];
    //初始化歌词的数据
    self.lyricArr=[[LyricHelper shareLyricHelper] allLyricItems];
    [player play];
    [self.lyricTbableView reloadData];

}

#pragma mark - Table view data source
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //先取到对应的歌词的model类对象
    LyricModel *lyric=[self.lyricArr objectAtIndex:indexPath.row];
    //对cell进行歌词的赋值
    cell.textLabel.text=lyric.string;
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricArr.count;
}
#pragma --mark旋转图片和加载进度条的协议方法
- (void)player:(HL_Player *)player didPlayWithTime:(float)time;
{
    //1.设置进度条
    self.sliderView.value=time;
    //2.设置当前播放了多少秒的label
    self.currentTimeLable.text=[self timeWithInterVal:time];
    //3.设置剩余时间还有多少时间没有播放的label
    self.remainTimeLable.text=[self timeWithInterVal:self.sliderView.maximumValue-self.sliderView.value];
    //4.旋转的图片
    self.revolveView.transform=CGAffineTransformRotate(self.revolveView.transform, M_PI/180);
    //5.实现歌词的滚动
    NSInteger index=[[LyricHelper shareLyricHelper]lyricIndexAttime:time];
    //根据歌词的下标找到对应的CELL
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:index inSection:0];
    [self.lyricTbableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionTop];
}
//处理时间格式
-(NSString *)timeWithInterVal:(float)interval
{
    int minute = interval/60;
    int second = (int)interval%60;
    NSString *str=[NSString stringWithFormat:@"%d:%02d",minute,second];
    return str;
}
//已经播放完之后的,下一首为空
-(void)playerDidfinishPlaying:(HL_Player *)player
{
    //下一首为空
    [self handleForwardAction:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}









@end
