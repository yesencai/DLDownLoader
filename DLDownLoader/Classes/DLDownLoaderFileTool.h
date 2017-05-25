//
//  DLDownLoaderFileTool.h
//  DLDownLoadLib
//
//  Created by yesencai@163.com on 2016/11/26.
//  Copyright © 2016年 yesencai@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLDownLoaderFileTool : NSObject

+ (BOOL)isFileExists: (NSString *)path;

+ (long long)fileSizeWithPath: (NSString *)path;

+ (void)moveFile:(NSString *)fromPath toPath: (NSString *)toPath;

+ (void)removeFileAtPath: (NSString *)path;

@end
