//
//  SmallVideoView.h
//  SmallVideo
//
//  Created by Xu Menghua on 15/12/4.
//  Copyright © 2015年 Xu Menghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SmallVideoViewDelegate <NSObject>
@optional

- (void)startRecord;
- (void)finishRecord;
- (void)cancelRecord;

@end

@interface SmallVideoView : UIView

@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *exitBtn;
@property (nonatomic, strong) UIView *timeLineView;
@property (nonatomic, strong) UILabel *promptLable;
@property (nonatomic, weak) id<SmallVideoViewDelegate> delegate;

@end
