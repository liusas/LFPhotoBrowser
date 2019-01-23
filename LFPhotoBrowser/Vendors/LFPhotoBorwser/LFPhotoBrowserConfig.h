//
//  LFPhotoBrowserConfig.h
//  LFPhotoBrowser
//
//  Created by 刘峰 on 18/12/12.
//  Copyright © 2018年 liufeng. All rights reserved.
//

#ifndef LFPhotoBrowserConfig_h
#define LFPhotoBrowserConfig_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/**<图片之间的间隔*/
#define PhotoBrowserImageViewMargin 10

/**<进度条的宽度*/
#define PhotoBrowserProgressWidth 50

/**<图片最大放大比例*/
#define ImageMaximumScale 2.0

/**<进度条类型*/
typedef NS_ENUM(NSUInteger, ProgressViewMode){
    ProgressViewModeLoopDiagram = 1,/**<环形*/
    ProgressViewModePieDiagram = 2/**<饼型*/
};

#endif /* LFPhotoBrowserConfig_h */
