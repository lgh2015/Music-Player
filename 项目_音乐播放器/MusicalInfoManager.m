//
//  MusicalInfoManager.m
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/10/29.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "MusicalInfoManager.h"
#import "MusicModel.h"

//自己创建一个延展 私有的属性
@interface MusicalInfoManager ()
//用来存放处理后的数据(model对象)
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation MusicalInfoManager

+(instancetype)shareManager
{
    //static 静态区 初始化一次  生命周期贯穿整个应用程序  作用域为全局
    //const  不涉及指针的时候 value和type是一样的,全局的
    //
    static MusicalInfoManager *manager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //初始化
        manager=[[MusicalInfoManager alloc]init];
    });
    return manager;
}
-(void)acquireData
{
    //1.网络请求
    NSArray *contents=[NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist" ]];
    
    //2.处理数据 给model类赋值
    for (NSDictionary *dict in contents) {
        //创建一个model类的对象
        MusicModel *model=[MusicModel musicInfoWithDictioray:dict];
        [self.dataArr addObject:model];
    }
    //发送通知的第二步,发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"KdataDidFinishAcquire" object:nil];
}
#pragma mark--- 懒加载,用得时候才开辟控件
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        //在初始化的时候必须要用属性
        self.dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}

-(id)modelofindex:(NSInteger)index
{
    return  self.dataArr[index];
}
-(NSInteger)modelCount
{
    return self.dataArr.count;
}


@end
