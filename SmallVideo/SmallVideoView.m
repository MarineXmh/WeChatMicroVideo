//
//  SmallVideoView.m
//  SmallVideo
//
//  Created by Xu Menghua on 15/12/4.
//  Copyright © 2015年 Xu Menghua. All rights reserved.
//

#import "SmallVideoView.h"

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@implementation SmallVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (SmallVideoView *)sharedSmallVideoView {
    static SmallVideoView *sharedSmallVideoView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSmallVideoView = [[self alloc] init];
    });
    CGFloat viewW = SCREEN_WIDTH;
    CGFloat viewH = SCREEN_HEIGHT * 0.64;
    CGFloat viewX = 0;
    CGFloat viewY = SCREEN_HEIGHT * 0.36;
    sharedSmallVideoView.frame = CGRectMake(0, SCREEN_HEIGHT, viewW, viewH);
    [UIView animateWithDuration:0.3 animations:^{
        sharedSmallVideoView    .frame = CGRectMake(viewX, viewY, viewW, viewH);
    }];
    return sharedSmallVideoView;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        CGFloat viewW = SCREEN_WIDTH;
        CGFloat viewH = SCREEN_HEIGHT * 0.64;
        CGFloat viewX = 0;
        CGFloat viewY = SCREEN_HEIGHT * 0.36;
        self.frame = CGRectMake(0, SCREEN_HEIGHT, viewW, viewH);
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(viewX, viewY, viewW, viewH);
        }];
        self.backgroundColor = [UIColor blackColor];
        
        [self setButtons];
    }
    
    return self;
}

- (void)setButtons {
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordBtn.frame = CGRectMake(self.center.x - 20, self.frame.size.height - 48, 40, 40);
    self.recordBtn.layer.cornerRadius = self.recordBtn.frame.size.width / 2;
    self.recordBtn.layer.masksToBounds = YES;
    self.recordBtn.layer.borderColor = [UIColor greenColor].CGColor;
    self.recordBtn.layer.borderWidth = 2;
    [self.recordBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchDragExit];
    [self.recordBtn addTarget:self action:@selector(finishRecord) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.recordBtn];
    
    self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitBtn.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 48, 40, 40);
    [self.exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [self.exitBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.exitBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.exitBtn];
}

- (void)setTimeLine {
    self.timeLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.width * 3 / 4, SCREEN_WIDTH, 1)];
    self.timeLineView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.timeLineView];
}

-(void)setPromptLable
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, self.frame.size.height - 100, 100, 30)];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    
    UILabel *promptLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    promptLable.backgroundColor = [UIColor clearColor];
    promptLable.textColor = [UIColor greenColor];
    promptLable.text = @"上移取消";
    promptLable.textAlignment = NSTextAlignmentCenter;
    promptLable.clipsToBounds = YES;
    [view addSubview:promptLable];
    self.promptLable = promptLable;
}

- (void)startRecord {
    NSLog(@"startRecord");
    [self setTimeLine];
    [self setPromptLable];
    self.recordBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [UIView animateWithDuration:10.0 animations:^{
        self.timeLineView.frame = CGRectMake(SCREEN_WIDTH / 2, self.frame.size.width * 3 / 4, 0, 1);
    } completion:^(BOOL finished) {
        [self finishRecord];
        if ([self.delegate respondsToSelector:@selector(finishRecord)]) {
            [self.delegate finishRecord];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"animationEnd" object:nil];
    }];
    if ([self.delegate respondsToSelector:@selector(startRecord)]) {
        [self.delegate startRecord];
    }
}

- (void)finishRecord {
    NSLog(@"finishRecord");
    [self.timeLineView removeFromSuperview];
    [self.promptLable removeFromSuperview];
    self.recordBtn.layer.borderColor = [UIColor greenColor].CGColor;
    if ([self.delegate respondsToSelector:@selector(finishRecord)]) {
        [self.delegate finishRecord];
    }
    [self exit];
}

- (void)cancelRecord {
    NSLog(@"cancelRecord");
    [self.timeLineView removeFromSuperview];
    [self.promptLable removeFromSuperview];
    self.recordBtn.layer.borderColor = [UIColor greenColor].CGColor;
}

- (void)exit {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame  = self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 0.64);
    } completion:^(BOOL finished) {
        
    }];
}

@end
