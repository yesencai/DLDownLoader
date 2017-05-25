//
//  DLDownLoadManager.m
//  DLDownLoadLib
//
//  Created by yesencai@163.com on 2016/11/27.
//  Copyright © 2016年 yesencai@163.com. All rights reserved.
//

#import "DLDownLoadManager.h"
#import "NSString+DLDownLoader.h"

@interface DLDownLoadManager()

@property (nonatomic, strong) NSMutableDictionary <NSString *, DLDownLoader *>*downLoadInfo;

@end


@implementation DLDownLoadManager

// 绝对的单例: 无论通过什么样的方式, 创建, 都是一个对象
// 非绝对的单例
static DLDownLoadManager *_shareInstance;
+ (instancetype)shareInstance {
    if (!_shareInstance) {
        _shareInstance = [[DLDownLoadManager alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}


- (NSMutableDictionary *)downLoadInfo {
    if (!_downLoadInfo) {
        _downLoadInfo = [NSMutableDictionary dictionary];
    }
    return _downLoadInfo;
}

- (void)downLoadWithURL: (NSURL *)url downLoadInfo: (DownLoadInfoType)downLoadBlock progress:(DownLoadProgress)progressBlock success: (DownLoadSuccessType)successBlock failed: (DownLoadFailType)failBlock{

    NSString *md5 = [url.absoluteString md5Str];
    
    DLDownLoader *downLoader = self.downLoadInfo[md5];
    if (downLoader) {
        [downLoader resume];
        return ;
    }
    downLoader = [[DLDownLoader alloc] init];
    [self.downLoadInfo setValue:downLoader forKey:md5];
    
    __weak typeof(self) weakSelf = self;
    [downLoader downLoadWithURL:url downLoadInfo:downLoadBlock progress:^(float progress) {
        if (progressBlock) {
            progressBlock(progress);
        }
    }success:^(NSString *cacheFilePath) {
        [weakSelf.downLoadInfo removeObjectForKey:md5];
        if(successBlock) {
            successBlock(cacheFilePath);
        }
    } failed:^{
        [weakSelf.downLoadInfo removeObjectForKey:md5];
        if (failBlock) {
            failBlock();
        }
    }];
    
    return ;

    
    
}

- (DLDownLoader *)downLoadWithURL: (NSURL *)url
{
    
    // 文件名称  aaa/a.x  bb/a.x
    
    NSString *md5 = [url.absoluteString md5Str];
    
    DLDownLoader *downLoader = self.downLoadInfo[md5];
    if (downLoader) {
        [downLoader resume];
        return downLoader;
    }
    downLoader = [[DLDownLoader alloc] init];
    [self.downLoadInfo setValue:downLoader forKey:md5];
    
    __weak typeof(self) weakSelf = self;
    [downLoader downLoadWithURL:url downLoadInfo:nil progress:nil success:^(NSString *cacheFilePath) {
        [weakSelf.downLoadInfo removeObjectForKey:md5];
    } failed:^{
        [weakSelf.downLoadInfo removeObjectForKey:md5];
    }];
    
    return downLoader;
    
}

- (DLDownLoader *)getDownLoaderWithURL: (NSURL *)url {
    NSString *md5 = [url.absoluteString md5Str];
    DLDownLoader *downLoader = self.downLoadInfo[md5];
    return downLoader;
}

- (void)pauseWithURL: (NSURL *)url {
    
    NSString *md5 = [url.absoluteString md5Str];
    DLDownLoader *downLoader = self.downLoadInfo[md5];
    [downLoader pause];
    
}

- (void)cancelWithURL: (NSURL *)url {
    NSString *md5 = [url.absoluteString md5Str];
    DLDownLoader *downLoader = self.downLoadInfo[md5];
    [downLoader cancel];
}
- (void)cancelAndClearWithURL: (NSURL *)url {
    NSString *md5 = [url.absoluteString md5Str];
    DLDownLoader *downLoader = self.downLoadInfo[md5];
    [downLoader cancelAndClearCache];
}

- (void)pauseAll {
    [[self.downLoadInfo allValues] makeObjectsPerformSelector:@selector(pause)];
}


- (void)resumeAll {
    [[self.downLoadInfo allValues] makeObjectsPerformSelector:@selector(resume)];
}


@end
