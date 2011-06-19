//
//  NuAppDelegate.m
//  NuApp
//
//  Created by Tim Burks on 6/11/11.
//  Copyright 2011 Radtastical Inc. All rights reserved.
//

#import "NuAppDelegate.h"

#import "NuBlock.h"
#import "NuBridgeSupport.h"
#import "NuCell.h"
#import "NuClass.h"
#import "NuDtrace.h"
#import "NuEnumerable.h"
#import "NuException.h"
#import "NuExtensions.h"
#import "NuHandler.h"
#import "NuMacro_0.h"
#import "NuMacro_1.h"
#import "NuMain.h"
#import "NuInternals.h"
#import "NuObject.h"
#import "NuOperator.h"
#import "NuParser.h"
#import "NuPointer.h"
#import "NuProfiler.h"
#import "NuReference.h"
#import "NuRegex.h"
#import "NuStack.h"
#import "NuSuper.h"
#import "NuSymbol.h"
#import "NuVersion.h"


@implementation NuAppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor greenColor];
    [self.window makeKeyAndVisible];
    
    NuInit();
    
    [[Nu sharedParser] parseEval:@"(load \"nu\")"];
    [[Nu sharedParser] parseEval:@"(load \"test\")"];
    
    NSString *resourceDirectory = [[NSBundle mainBundle] resourcePath];
    
    NSArray *files = [[NSFileManager defaultManager] 
                      contentsOfDirectoryAtPath:resourceDirectory
                      error:NULL];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"^test_.*nu$" options:0 error:NULL];             
    for (NSString *filename in files) {
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:filename
                                                            options:0
                                                              range:NSMakeRange(0, [filename length])];
        if (numberOfMatches) {
            NSLog(@"loading %@", filename);
            NSString *s = [NSString stringWithContentsOfFile:[resourceDirectory stringByAppendingPathComponent:filename]
                                                    encoding:NSUTF8StringEncoding
                                                       error:NULL];
            [[Nu sharedParser] parseEval:s];
        }
    }
    [regex release];
    NSLog(@"running tests");
    [[Nu sharedParser] parseEval:@"(NuTestCase runAllTests)"];
    NSLog(@"ok");    
    return YES;
}

@end
