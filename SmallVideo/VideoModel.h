//
//  VideoModel.h
//  SmallVideo
//
//  Created by Xu Menghua on 15/12/7.
//  Copyright © 2015年 Xu Menghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface VideoModel : NSObject <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureMovieFileOutput *output;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *AVPlayerLayer;
@property (nonatomic, strong) NSString *videoPath;

- (void)setRecVideoAndVideoPreviewLayer:(UIView *)view;
- (void)beginRecordSaveToTheDocumentFilePath:(NSString *)filePath; //开始录制视频 并存到沙箱中
- (void)stopVideoRecorder;

@end
