//
//  DLDownLoader.h
//  DLDownLoadLib
//
//  Created by yesencai@163.com on 2016/11/26.
//  Copyright © 2016年 yesencai@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDownLoadURLOrStateChangeNotification @"downLoadURLOrStateChangeNotification"

typedef enum : NSUInteger {
    DLDownLoaderStateUnKnown,
    /** 下载暂停 */
    DLDownLoaderStatePause,
    /** 正在下载 */
    DLDownLoaderStateDowning,
    /** 已经下载 */
    DLDownLoaderStateSuccess,
    /** 下载失败 */
    DLDownLoaderStateFailed
} DLDownLoaderState;


typedef void(^DownLoadInfoType)(long long fileSize);
typedef void(^DownLoadSuccessType)(NSString *cacheFilePath);
typedef void(^DownLoadFailType)();
typedef void(^DownLoadProgress)(float progress);

@interface DLDownLoader : NSObject

// 如果当前已经下载, 继续下载, 如果没有下载, 从头开始下载
- (void)downLoadWithURL: (NSURL *)url;

+ (NSString *)downLoadedFileWithURL: (NSURL *)url;
+ (long long)tmpCacheSizeWithURL: (NSURL *)url;
+ (void)clearCacheWithURL: (NSURL *)url;


- (void)downLoadWithURL: (NSURL *)url downLoadInfo: (DownLoadInfoType)downLoadBlock progress:(DownLoadProgress)progress success: (DownLoadSuccessType)successBlock failed: (DownLoadFailType)failBlock;

// 恢复下载
- (void)resume;

// 暂停, 暂停任务, 可以恢复, 缓存没有删除
- (void)pause;

// 取消
- (void)cancel;

// 缓存删除
- (void)cancelAndClearCache;

// 状态
@property (nonatomic, assign, readonly) DLDownLoaderState state;

// 进度
@property (nonatomic, assign) float progress;

// 下载进度
@property (nonatomic, copy) DownLoadProgress downLoadProgress;

// 文件下载信息 (下载的大小)
@property (nonatomic, copy) DownLoadInfoType downLoadInfo;

// 状态的改变 ()
@property (nonatomic, copy) void(^downLoadStateChange)(DLDownLoaderState state);

// 下载成功 (成功路径)
@property (nonatomic, copy) DownLoadSuccessType downLoadSuccess;

// 失败 (错误信息)
@property (nonatomic, copy) DownLoadFailType downLoadError;


@end
