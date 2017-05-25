#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DLDownLoader.h"
#import "DLDownLoaderFileTool.h"
#import "DLDownLoadManager.h"
#import "NSString+DLDownLoader.h"

FOUNDATION_EXPORT double DLDownLoaderVersionNumber;
FOUNDATION_EXPORT const unsigned char DLDownLoaderVersionString[];

