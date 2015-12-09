//
//  VideoModel.m
//  SmallVideo
//
//  Created by Xu Menghua on 15/12/7.
//  Copyright © 2015年 Xu Menghua. All rights reserved.
//

#import "VideoModel.h"

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface VideoModel () {
    UIView *_view;
    UIView *_subView;
}
@end

@implementation VideoModel

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"animationEnd" object:nil];
}

- (id)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationEnd:) name:@"animationEnd" object:nil];
    }
    
    return self;
}

-(void)animationEnd:(NSNotification *)info {
    [self stopVideoRecorder];
}

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    [self.AVPlayerLayer removeFromSuperlayer];
}

-(void)setRecVideoAndVideoPreviewLayer:(UIView *)view {
    _view = view;
    
    _subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH * 3 / 4))];
    [_subView sendSubviewToBack:view];
    [view addSubview:_subView];
    
    //1.创建视频设备(摄像头前，后)
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //2.初始化一个摄像头输入设备(first是后置摄像头，last是前置摄像头)
    AVCaptureDeviceInput *inputVideo = [AVCaptureDeviceInput deviceInputWithDevice:[devices firstObject] error:NULL];
    //3.创建麦克风设备
    AVCaptureDevice *deviceAudio = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //4.初始化麦克风输入设备
    AVCaptureDeviceInput *inputAudio = [AVCaptureDeviceInput deviceInputWithDevice:deviceAudio error:NULL];
    //5.初始化一个movie的文件输出
    AVCaptureMovieFileOutput *output = [[AVCaptureMovieFileOutput alloc] init];
    //保存output，方便下面操作
    self.output = output;
    //三,初始化会话，并将输入输出设备添加到会话中
    //6.初始化一个会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPreset1280x720;
    //7.将输入输出设备添加到会话中
    if ([session canAddInput:inputVideo]) {
        [session addInput:inputVideo];
    }
    if ([session canAddInput:inputAudio]) {
        [session addInput:inputAudio];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    //8.创建一个预览涂层
    AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    preLayer.clipsToBounds = YES;
    //设置图层的大小
    preLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width * 3 / 4));
    //添加到view上
    [_subView.layer addSublayer:preLayer];
    //五，开始会话
    //9.开始会话
    [session startRunning];
}

//开始录制视频 并存到沙箱中
- (void)beginRecordSaveToTheDocumentFilePath:(NSString *)filePath {
    if (_AVPlayerLayer != nil) {
        [self.player pause];
        [self.AVPlayerLayer removeFromSuperlayer];
    }
    self.videoPath = filePath;
    //10.开始录制视频
    //转为视频保存的url
    //    NSString *timeTikesName = [NSString stringWithFormat:@"%.f", ([[NSDate date] timeIntervalSince1970]*1000)];
    //    _filePath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",timeTikesName]];
    NSURL *url = [NSURL fileURLWithPath:self.videoPath];
    //开始录制,并设置控制器为录制的代理
    [self.output startRecordingToOutputFileURL:url recordingDelegate:self];
}

- (void)stopVideoRecorder; {
    if ([self.output isRecording]) {
        [self.output stopRecording];
    }
}

//获取视频时长
- (CGFloat) getVideoLength:(NSURL *)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

//获取视频大小（返回值为KB）
- (CGFloat) getFileSize:(NSString *)path {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}

@end
