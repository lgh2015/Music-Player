//
//  LyricHelper.m
//  项目_音乐播放器
//
//  Created by 李国灏 on 15/11/3.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "LyricHelper.h"
#import "LyricModel.h"
@interface LyricHelper ()
//存放处理后的歌词
@property(nonatomic,strong)NSMutableArray *lyricInfoArray;
//记录歌词的下标
@property(nonatomic)NSInteger index;

@end


@implementation LyricHelper

-(NSMutableArray *)lyricInfoArray
{
    if (!_lyricInfoArray) {
        self.lyricInfoArray=[[NSMutableArray alloc]init];
    }
    return _lyricInfoArray;
}
+(instancetype)shareLyricHelper
{
    static LyricHelper *lyric=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lyric=[[LyricHelper alloc]init];
    });
    return lyric;
}
-(void)setLyricWithString:(NSString *)string
{
    //把歌词分割成一句一句的放在数组中
    NSArray *lyricStatementArray=[string componentsSeparatedByString:@"\n"];
    self.index=0;
    //每次存在歌词前,先把原来的歌词清空
    [self.lyricInfoArray removeAllObjects];
    //接着对每一句歌词进行处理
    for (int i=0; i<lyricStatementArray.count-1; i++) {
        //[02:42.520]悲伤坚决不放手
        //取到每一句话
        NSString *statement=lyricStatementArray[i];
        //0----分割[02:42.520]
        //1----悲伤坚决不放手
        if ([statement containsString:@"]"]) {
        NSArray *arr=[statement componentsSeparatedByString:@"]"];
        //leftString----02:42.520
        NSString *leftString=[arr[0] substringFromIndex:1];
        //rightstring----悲伤坚决不放手
        NSString *rightString=arr[1];
        //将正确的时间格式转化为数字总时间,因为需要根据时间来做判断,转化为数字更方便比较
        //0---02
        //1---41.520
//        if (leftString!=nil) {
        NSArray *timeArr=[leftString componentsSeparatedByString:@":"];
        NSString *minute=timeArr[0];
        NSString *seconde=timeArr[1];
        NSTimeInterval time = [minute intValue]* 60 +[seconde doubleValue];
        //将处理好的时间和歌词赋值给model
        LyricModel *lyric=[[LyricModel alloc]initWithCurrentTime:time string:rightString];
        //将赋值完毕的model对象存放在数组中
        [self.lyricInfoArray addObject:lyric];
        }
    }
}
#pragma ---mark 根据时间找到相对应的歌词的下标
-(NSInteger)lyricIndexAttime:(NSTimeInterval)time
{
    for (int i=0; i<self.lyricInfoArray.count; i++) {
        //取出来每一句歌词
        LyricModel *lyric=self.lyricInfoArray[i];
        //拿每一句的时候都和给定的这个时间进行比较,找到第一个不满足情况,因为不满足情况,但是这一次循环已经执行了,所以满足情况的歌词就是上一句
        if (lyric.currentTime>time) {
            if (i==0) {
                self.index=0;
            }
            else{
                self.index=i-1;
            }
            break;//找到就跳出循环
        }
    }
    return self.index;
}
-(NSMutableArray *)allLyricItems
{
    return self.lyricInfoArray;
}






















@end
