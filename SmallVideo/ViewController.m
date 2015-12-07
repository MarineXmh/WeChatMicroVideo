//
//  ViewController.m
//  SmallVideo
//
//  Created by Xu Menghua on 15/12/4.
//  Copyright © 2015年 Xu Menghua. All rights reserved.
//

#import "ViewController.h"
#import "SmallVideoView.h"
#import "VideoModel.h"

@interface ViewController () <SmallVideoViewDelegate>

@property (nonatomic, strong) SmallVideoView *smallVideoView;
@property (nonatomic, strong) VideoModel *videoModel;
@property (nonatomic, strong) NSString *filePath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)smallVideo:(UIButton *)sender {
    self.smallVideoView = [[SmallVideoView alloc] init];
    [self.view addSubview:self.smallVideoView];
    self.videoModel = [[VideoModel alloc] init];
    [self.videoModel setRecVideoAndVideoPreviewLayer:self.smallVideoView];
}

- (void)startRecord {
    NSString *timeTikesName = [NSString stringWithFormat:@"%.f", ([[NSDate date] timeIntervalSince1970] * 1000)];
    NSString *filePath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",timeTikesName]];
    self.filePath = filePath;
    [self.videoModel beginRecordSaveToTheDocumentFilePath:filePath];
    NSLog(@"开始录制");
}

- (void)finishRecord {
    
}

- (void)cancelRecord {
    
}

@end
